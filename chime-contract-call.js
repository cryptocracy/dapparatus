```
//reference https://www.npmjs.com/package/@stacks/transactions

//Network
const network = new stacksNetwork.StacksMainnet();

//Fungible Token Contract Info
const ftcontractid = "SP3T3JC6V4S94PPB7WFEK17863HPG3EYP6CJ65E7M.luv"; //get our contract id
const ftname = ftcontractid.split(".")[1]; //remove everything prior and including "."
const ftaddress = ftcontractid.split(".")[0]; //remove everything after and including "."
const ftamount = 1;

//Sender
const senderkey = ""; //the auth'd users 
const ftsender = ""; //the auth'd users principal as

//Message and Attachment URL
const content = msg.payload.ftmessage;//pass in the memo
const attachmentUri = msg.payload.fturl;//pass in the attachment url

//Post Conditions for safety
const postConditionAddress = ftsender;
const postConditionCode = stacksTransactions.FungibleConditionCode.Equal;
const postConditionAmount = new BigNum(1); //requires BigNum
const postConditionAssetInfo = stacksTransactions.createAssetInfo(ftaddress, "luv", "luv");

const postConditions = [
  stacksTransactions.makeStandardFungiblePostCondition(postConditionAddress, postConditionCode, postConditionAmount, postConditionAssetInfo),
];

//Transaction Options
const txOptions = {
  contractAddress: ftaddress,
  contractName: ftname,
  functionName: 'send-message',
  functionArgs: [
      stacksTransactions.stringUtf8CV(content),
      stacksTransactions.someCV(stacksTransactions.stringUtf8CV(attachmentUri))
      ],
  senderKey: senderkey,
  validateWithAbi: true,
  network,
  postConditions,
  anchorMode: stacksTransactions.AnchorMode.Any,
};

//Transaction Broadcast to Network
const transaction = await stacksTransactions.makeContractCall(txOptions);
const broadcastTxn = await stacksTransactions.broadcastTransaction(transaction, network);

//Passed along Outputs for UI
msg.payload = transaction;
msg.blockchain = "0x" + broadcastTxn;//the transaction id
msg.txoptions = txOptions;//the tx options
msg.ftcontractid = ftcontractid;//full contract id
msg.ftname = ftname;//contract name
msg.ftaddress = ftaddress;//contract address
msg.ftsender = ftsender; //contract caller

return msg;
