import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodoModel extends ChangeNotifier {
  List<Todo> todos = [];
  bool isLoading = true;
  int taskCount = 0;
  final String rpcUrl = "http://192.168.43.206:8545";
  final String wsUrl = "ws://192.168.43.206:8545/";

  final String privateKey =
      "38e20ae483ca58d359e5eb8402709d26e84ec05ef8c3654368130bb25a743248";

  Web3Client? _client;
  String? _abiCode;
  Credentials? _credentials;
  EthereumAddress? _contractAddress;
  EthereumAddress? _ownAddress;
  DeployedContract? _deployedContract;
  ContractFunction? _taskCount;
  ContractFunction? _todos;
  ContractFunction? _createdTodo;
  // ContractEvent? _todoCreated;

  TodoModel() {
    initSetup();
  }

  initSetup() async {
    _client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
    await getABI();
    await getCredentials();
    await getContractDeployed();
  }

  Future<void> getABI() async {
    String abiCode = await rootBundle.loadString("src/abis/TodoList.json");
    var jsonABI = jsonDecode(abiCode);
    _abiCode = jsonEncode(jsonABI["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
    print(_contractAddress!);
  }

  Future<void> getCredentials() async {
    _credentials = await _client!.credentialsFromPrivateKey(privateKey);
    _ownAddress = await _credentials!.extractAddress();
  }

  Future<void> getContractDeployed() async {
    _deployedContract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, "TodoList"), _contractAddress!);
    _taskCount = _deployedContract!.function("taskCount");
    _todos = _deployedContract!.function("todos");
    _createdTodo = _deployedContract!.function("createTodo");
    // _todoCreated = _deployedContract!.event("todoCreated");
    getTodos();
  }

  getTodos() async {
    List totalTaskList = await _client!
        .call(contract: _deployedContract!, function: _taskCount!, params: []);

    BigInt totalTasks = totalTaskList[0];
    taskCount = totalTasks.toInt();
    print(totalTasks);
    todos.clear();

    for (var i = 0; i < totalTasks.toInt(); i++) {
      var temp = await _client!.call(
          contract: _deployedContract!,
          function: _todos!,
          params: [BigInt.from(i)]);
      todos.add(Todo(temp[0], temp[1]));
    }
    isLoading = false;
    print(todos[0]);
    notifyListeners();
  }

  addTodo(String taskNameData) async {
    isLoading = true;
    notifyListeners();
    await _client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _deployedContract!,
            function: _createdTodo!,
            parameters: [taskNameData]));

    getTodos();
  }
}

class Todo {
  String taskName;
  bool isCompleted;
  Todo(this.taskName, this.isCompleted);
}
