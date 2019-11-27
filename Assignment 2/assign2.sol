pragma solidity ^0.5.12;

contract assign2 {
    string storedMessage;
    struct Shareholder {
        address participant; // shareholders address
        uint[] questionsvoted; // indics of question voted on
        uint canvote;
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
    
    function uploadquestion(string memory askquestion) public onlyDirector {
        questions.push(Question({quest: askquestion, isOpen:true, result:0})); // Asked questions are added to the array questions
        
        //can send a notification at this point
        emit affirmquestion(msg.sender, askquestion, "Has been uploaded");
    }
    
    // set the question.isOpen to false
    function closequestion(uint8 index ) public onlyDirector{
        Question storage whichquestion = questions[index];
        whichquestion.isOpen = false;
        emit affirmquestion(msg.sender, whichquestion.quest, "Has been closed");
    }
    
    
    
    //add or remove shareholders
    function addshareholder(address shareholderaddr ) public onlyDirector{
        
        require(shareholders[shareholderaddr].participant != shareholderaddr, "Shareholder already exists");
        
        shareholders[shareholderaddr].participant = shareholderaddr;
        shareholders[shareholderaddr].canvote = 1;
        emit affirmshareholder(shareholderaddr, "has been added to shareholders");
    }
    
    function removeshareholder(address shareholderaddr) public onlyDirector {
        
        if(shareholders[shareholderaddr].participant != shareholderaddr)// check if the address exists
            revert("No such shareholder exists");
            
        shareholders[shareholderaddr].canvote = 0; //remove the ability to participate in voting
        emit affirmshareholder(shareholderaddr, "Can nolonger participate in voting");
    }
    
    function voting(uint8 qindex, bool vote) public{
        // can vote for multiple questions
        Question storage votingqn = questions[qindex];
        require(votingqn.isOpen == true);
        Shareholder storage voter = shareholders[msg.sender];
        
        //check if voter has already voted on a given question
        bool foundqn =false;
        for(uint i =0; i<voter.questionsvoted.length; i++){
            if(qindex == voter.questionsvoted[i])
                foundqn =true;
        }
        require(!foundqn, "Shareholder has already voted on this question");
        
        require(voter.canvote == 1, "You can nolonger vote");
        voter.questionsvoted.push(qindex); // add index of question voted on
        
        if(vote){// voting in favor
            questions[qindex].result += 1;
        }else{
            questions[qindex].result -= 1;
        }
    }
    
    
    //closing of specific question and display results
    function closeandresult(uint8 qindex) public view returns(string memory finalresult){
        //check if the Shareholder can participate
        require(shareholders[msg.sender].canvote==1, "Results only visible to acive shareholders");
        
        Question storage closeqn = questions[qindex];
        require(closeqn.isOpen == false, "Question is still Open");
        
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
