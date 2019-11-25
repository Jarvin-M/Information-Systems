pragma solidity ^0.5.12;

contract assign2 {
    string storedMessage;
    struct Shareholder {
        address participant; // shareholders address
        uint8 question; // index of question voted on
        bool vote; //true or false vote
        uint canvote;
        bool hasvoted; //true if the person has voted
    }
    
    struct Question {
        string quest; // string of the question
        bool isOpen; // close or open the question
        uint8 result; // result of voting of the question
        
    }
    
    Question[] public questions;
    // state variable that stores Shareholder struct for each address
    mapping(address=>Shareholder) shareholders;
    
    constructor() public { director = msg.sender; }
    address public director;
    
    modifier onlyDirector() { // Modifier checks the condition is met before executing the function
        require(
            msg.sender == director,
            "Only Director can perform this step."
        );
        _;
    }
    
    // Upload any questions with true or false response one at a time
    event affirmquestion(address uploader, string question, string confirmstr);
    event affirmshareholder(address shareholder, string confirmstr);
    
    function uploadquestion(string memory askquestion) public payable onlyDirector {
        questions.push(Question({quest: askquestion, isOpen:true, result:0})); // Asked questions are added to the array questions
        
        //can send a notification at this point
        emit affirmquestion(msg.sender, askquestion, "Has been uploaded");
    }
    
    // set the question.isOpen to false
    function closequestion(uint8 index ) public payable onlyDirector{
        Question storage whichquestion = questions[index];
        whichquestion.isOpen = false;
        emit affirmquestion(msg.sender, whichquestion.quest, "Has been closed");
    }
    
    
    
    //add or remove shareholders
    function addshareholder(address shareholder ) public payable onlyDirector{
        require(!shareholders[shareholder].hasvoted, "Shareholder can only vote once");
        require(shareholders[shareholder].canvote == 0);
        shareholders[shareholder].canvote = 1;
        emit affirmshareholder(shareholder, "has been added to shareholders");
    }
    
    function removeshareholder(address shareholder) public payable onlyDirector {
        require(shareholders[shareholder].canvote == 1);
        shareholders[shareholder].canvote = 0;
        emit affirmshareholder(shareholder, "has been removed to shareholders");
    }
    
    function voting(uint8 qindex, bool vote) public{
        Question storage votingqn = questions[qindex];
        require(votingqn.isOpen == true);
        Shareholder storage voter = shareholders[msg.sender];
        
        require(!voter.hasvoted, "Shareholder can only vote once");
        require(voter.canvote == 1);
        voter.hasvoted =true;
        voter.question = qindex;
        if(vote){// voting in favor
            questions[qindex].result += 1;
        }else{
            questions[qindex].result -= 1;
        }
    }
    
    
    //closing of specific question and display results
    function closeandresult(uint8 qindex) public view returns(string memory finalresult){
        Question storage closeqn = questions[qindex];
        require(closeqn.isOpen == false);
        // closeqn.isOpen =  false;
        
        if(closeqn.result >0){
            finalresult = "Majority in favor";
            return finalresult;
        }else if (closeqn.result <0){
            finalresult = "Majority against";
            return finalresult;
        }else{
            finalresult = "Tie";
            return finalresult;
        }
        
    }
}
