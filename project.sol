//Lonewolf
//SPDX-License-Identifier: Unlicense
pragma solidity>=0.5.0 <0.9.0;
contract Eventmanage{
    struct Event{
        address organizer;
        string name;
        string location;
        uint eventDate; 
        uint price;
        uint ticketCount;  
        uint ticketRemain;
    }
    mapping(uint=>Event) public events; //for multiple events
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;
    function createEvent(string memory name,string memory location,uint eventDate,uint price,uint ticketCount)external {
        require(eventDate>block.timestamp,"You should have to organize event for the future date");
        require(ticketCount>0,"You can organize event only if you create more than 0 tickets");
        

   events[nextId] = Event(msg.sender, name, location, eventDate, price, ticketCount, ticketCount);
        nextId++;
    }
    function buyticket(uint id,uint quantity)external payable{
        require(events[id].eventDate!=0,"Event does not exist");
        require(events[id].eventDate>block.timestamp,"Event has already occured");
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity),"Ether is not enough");
        require(_event.ticketRemain>=quantity,"Not enough tickets");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;

    }
    function transfertickets(uint id,uint quantity,address to)external{
        require(events[id].eventDate!=0,"Event does not exist");
        require(events[id].eventDate>block.timestamp,"Event has already occured");
        require(tickets[msg.sender][id]>=quantity,"You don't have enough tickets.");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;

    }
     function refundTickets(uint id, uint quantity) external {
        require(events[id].eventDate != 0, "Event does not exist");
        require(events[id].eventDate > block.timestamp, "Event has already occurred");
        require(tickets[msg.sender][id] >= quantity, "You don't have enough tickets.");
        Event storage _event = events[id];
        _event.ticketRemain += quantity;
        tickets[msg.sender][id] -= quantity;
        uint refundAmount = _event.price * quantity;
        payable(msg.sender).transfer(refundAmount);
    }

    
}