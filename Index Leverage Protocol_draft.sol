// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

/*
임의의 Index를 설정해서 leverage 거래를 할 수 있는 프로토콜. 
아직 미완성이고 계속 수정중임. 
Liquidity Provider는 시장을 개설하고 Pool에 자금을 투입함. 
Trader는 해당 시장에 Long/short, leverage 비율을 정해서 포지션에 진입함. 
Trader가 하는 모든 거래의 상대방은 Pool임. 각각의 Pool들은 독립적임. 
LP는 receipt 토큰으로 ERC-20토큰을 받음. 
Trader들의 모든 포지션은 모두 다르기 때문에 trader들은 receipt token으로 NFT를 받음. 
*/


contract TradingPool is IERC20 {

//모든 거래를 USDT로만 함. 다른 토큰은 받지 않음.     
    address public constant USDT = 0xdac17f958d2ee523a2206206994597c13d831ec7;
    IERC20 private usdt = IERC20(USDT);
    uint public poolValue; //LP가 공급한 Pool의 현재가치
    uint public receiptTokenTotalSupply; // LP receipToken의 총 수량.
    enum LongShort {
        Long,
        Short
    }
    LongShort public longShort = LongShort.long;
    enum ClearHouse {
        Safe,
        Zero
    }
    ClearHouse public clearHouse = ClearHouse.Safe;

// PositionInfo는 Trader들이 진입했을 때의 정보를 저장하고 갱신될 때,
// 청산이 되었는지 아닌지 여부를 저장함. 
    struct PositionInfo {
        uint nftId;
        uint initialValue;
        uint enterIndex;
        uint leverage;
        enum longShort;
        enum clearHouse;
    }
    PotionInfo[] public positionInfo;

    function addLiquidity(
        address _addr,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(_addr == USDT, "Invaild token!");
// approve 대신 permit을 사용해서 토큰을 받음. 
        IERC20Permit(token).permit(msg.sender, address(this), amount, deadline, v, r, s);
        if(poolValue == 0) {
            uint public amountToMint = amount;
        } else {
            amountToMint = amount/poolValue * receiptTokenTotalSupply;
        }
        NFTManager.Mint(msg.sender);
        poolValue = poolValue + amount;
        emit // LP가 자금을 추가했음을 event로 알림. 
    }

    function removeLiquidity(address _addr, uint _amount) external {
        require(_addr == USDT, "Invaild token!");
        //일반정산함수 호출. 
        //호출하고 난 뒤에는 모든 포지션과 Pool의 청산 여부가 업데이트됨. 
        if (poolValue == 0) {
            uint public returnValue = 0;
        } else {
            returnValue = _amount/receiptTokenTotalSupply * poolValue;
        }
        usdt.transferFrom(address(this), msg.sender, returnValue);
        balanceOf[msg.sender] -= _amount;
        receiptTokenTotalSupply -= _amount;
        emit // LP가 자금을 회수했음을 event로 알림. 
    }

    function enterPosition(
        address _addr, 
        uint _amount, 
        uint _enterIndex, 
        uint8 _leverage, 
        longShort _longShort
    ) external {
        require(_addr == USDT, "Invaild token!");
        nftid = NftManager.Mint();
        positionInfo[] = (nftid, _amount, _enterIndex, _leverage, _longShort, Safe);
    }

    function positionClearCall(uint _id) external {
        if(positionInfo[_id] == zero) {
            emit //단일 포지션이 청산되었음을 이벤트로 알림.
        }
        if(poolValue == 0) {
            emit // Pool이 청산되었음을 이벤트로 알림.
            uint returnValue = positionInfo[_id];
            IERC20(usdt).transfer(address(this), msg.sender, returnValue);
        }
        //일반정산 함수 호출. 
        // 호출후에는 모든 포지션과 Pool의 청산여부가 업데이트 됨. 
        uint valueOfThePostion = positonValue[_id];
        if(poolValue == 0) {
            // 이벤트 풀 청산
            uint returnValue = positionInfo[_id];
            IERC20(usdt).transfer(address(this), msg.sender, returnValue);
        } else {
            //returnValue = 단일포지션계산함수 호출(_id)
            // 일반정산 함수는 청산여부만을 업데이트하기 때문에 특정 포지션의 
            // 현재가치는 단일포지젼계산함수로 별도로 계산해줘야 함. 
            IERC20(usdt).transfer(address(this), msg.sender, returnValue);
        }
    }

    function onePositionValueCalculate(uint _id) internal returns(uint _num) {
        //체인링크 값 읽어와서 local variable result에 저장
        
        
        
        struct PositionInfo {
        uint nftId;
        uint initialValue;
        uint enterIndex;
        uint leverage;
        enum longShort;
        enum clearHouse;
    }
    }
}


/*
5. 단일 포지션 가치 계산
해당 포지션의 가치 계산. 결과값을 반환. 
*/







