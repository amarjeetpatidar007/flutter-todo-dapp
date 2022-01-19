//SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.5.0 < 0.9.0;

contract TodoList{
    uint public taskCount;

    struct Todo{
        string todoName;
        bool isCompleted;
    }

    constructor() public {
        taskCount = 0;
    }

    mapping(uint => Todo) public todos;
    event TodoCreated(string task, uint todoNumber);

    function createTodo(string memory _taskName) public {
    // add task to Todo & increment taskCount
    todos[taskCount++] = Todo(_taskName,false);

    //emit event
    emit TodoCreated(_taskName, taskCount - 1);
    }

}