pragma solidity ^0.4.24;

contract CreateIdeas {
    //Token
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public ownerSupply;
    uint256 public totalSupply; 
    uint256 initialSupply = 1000000e18;
    uint256 _totalSupply = 9999999999999e18;
    uint256 public circulatingSupply;
    string tokenName = "Ship Ideas";
    string tokenSymbol = "IDEA";
    address owner;
    //Helper
    uint256 public postCount = 0;
    uint256 smallestValue;
    uint256 maxPosts = 200;
    uint256 public location = 0;
    uint256 public once;
    uint256 exists;
    address[] topAddresses;
    Post[] public top;
    //Mappings
    mapping(address => uint256) public balanceOf;
    mapping(uint256 => Post) public posts;
    mapping(uint256 => mapping(uint256 => address[])) public liked;
    //Modifiers
    modifier OnlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier reset(){
        if (once + 86400 <= now){
            assert(once + 86400 <= now);
            for(uint8 i=0; i < top.length; i++){
                balanceOf[top[i].person] += 1728e18;
                posts[top[i].id].likes = 0;
                delete top[i];
                circulatingSupply += 1728e18;
            }
            top.length = 0;
            once = now;
            smallestValue = 0;
            balanceOf[msg.sender] += 1728e18;
            balanceOf[owner] += 300e18;
            circulatingSupply += 2028e18;
        }
     _;    
    }
    
    //Events
    event TopPostAdded(uint256 id);
    event PostAdded(uint256 id);
    event Transfer(address _from, address _to, uint256 _value);
    
    struct Post {
        uint256 id;
        uint256 likes;
        string title;
        string message;
        address person;
        uint256 timestamp;
        
    }
    
   
    constructor() public {
        owner = msg.sender;
        ownerSupply = initialSupply;
        circulatingSupply = initialSupply;
        totalSupply = _totalSupply;
        balanceOf[owner] = ownerSupply;
        name = tokenName;
        symbol = tokenSymbol;
        smallestValue = 0;
        once = now;
        top.length = 0;
    }
    
    
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        
        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
        
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success){
        _transfer(msg.sender, _to, _value);
        return true;
    }
    
    function addPost(string _title, string _message) public {
        require(msg.sender != 0);
        postCount +=1;
        uint256 _likes = 0;
        uint256 _timestamp = now;
        address _person = msg.sender;
        posts[postCount] = Post(postCount, _likes, _title, _message, _person, _timestamp);
        
        emit PostAdded(postCount);
    }

    function isLike(uint256 _id) public view returns(bool) {
        for(uint256 i = 0; i< liked[_id][_id].length; i++){
            if(liked[_id][_id][i] == msg.sender) return true;
        }
        return false;
    }
    
    function likePost(uint256 _id) reset public {
        require(msg.sender !=0);
        if(liked[_id][_id].length == 0){
          posts[_id].likes += 1;
          addtopPosts(_id);
          liked[_id][_id].push(msg.sender);
        }
        else {
          if(isLike(_id) == true){
          revert();
          }
          else {
          posts[_id].likes += 1;
          addtopPosts(_id);
          liked[_id][_id].push(msg.sender);
          }
        }
    }
    
    function disLikePost(uint256 _id) reset public {
        require(msg.sender != 0);
        require(posts[_id].likes > 0);
        posts[_id].likes -= 1;
        top[_id-1].likes -= 1;
    }
    
    function addtopPosts(uint256 _id) internal {
        if(top.length == 0){
            once = now;
            uint256 newSize = 1;
            top.length = newSize;
            Post memory save;
            save.id = posts[_id].id;
            save.likes = posts[_id].likes;
            save.title = posts[_id].title;
            save.message = posts[_id].message;
            save.person = posts[_id].person;
            save.timestamp = posts[_id].timestamp;
            top[0] = save;
            smallestValue = posts[_id].likes;
            emit TopPostAdded(_id);
        }
        
        if(posts[_id].likes > checkMinimumValue() && top.length < maxPosts){
            if(postExists(_id) == true){
                save.id = posts[_id].id;
                save.likes = posts[_id].likes;
                save.title = posts[_id].title;
                save.message = posts[_id].message;
                save.person = posts[_id].person;
                save.timestamp = posts[_id].timestamp;
                top[exists] = save;
            }
                else{
                    save.id = posts[_id].id;
                    save.likes = posts[_id].likes;
                    save.title = posts[_id].title;
                    save.message = posts[_id].message;
                    save.person = posts[_id].person;
                    save.timestamp = posts[_id].timestamp;
                    top.push(save);
                    emit TopPostAdded(_id);
                }
        }
        else if (posts[_id].likes > checkMinimumValue() && top.length == maxPosts){
            if(postExists(_id) == true){
                save.id = posts[_id].id;
                save.likes = posts[_id].likes;
                save.title = posts[_id].title;
                save.message = posts[_id].message;
                save.person = posts[_id].person;
                save.timestamp = posts[_id].timestamp;
                top[exists] = save;
            }
            else {
                checkMinimumValue();
                save.id = posts[_id].id;
                save.likes = posts[_id].likes;
                save.title = posts[_id].title;
                save.message = posts[_id].message;
                save.person = posts[_id].person;
                save.timestamp = posts[_id].timestamp;
                top[location] = save;
                emit TopPostAdded(_id);
            }
        }
        return;
        
    }
    
    function checkMinimumValue() public returns(uint256) {
        uint256 minimum  = top[0].likes;
                location = 0;
        for(uint8 i = 1; i < top.length; i++){
            if(top[i].likes < minimum){
                minimum = top[i].likes;
                location = i;
            }
        }
        smallestValue = minimum;
        return(smallestValue);
    }
    
    function postExists(uint256 _id) internal returns(bool){
        for(uint8 i = 0; i< top.length; i++){
            if(top[i].id == _id) {
                exists = i;
                return true;
            }
        }
          return false;
    }
    
}
