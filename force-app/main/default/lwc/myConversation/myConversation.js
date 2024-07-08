import { LightningElement, wire, api, track } from 'lwc';
import getConversationsByUser from '@salesforce/apex/ConversationController.getConversationsByUser';
import createPendingServiceRouting from '@salesforce/apex/ConversationController.createPendingServiceRouting'

const columns = [
  { label: 'Lead', fieldName: 'LeadName', type: 'text' },
  { label: 'Contato', fieldName: 'ContactName', type: 'text'},
  { label: 'Conta', fieldName: 'AccountName', type: 'text'},
  { label: 'Status', fieldName: 'Status', type: 'text'}
];

export default class MyConversation extends LightningElement {

@track conversationList = [];
columns = columns;
selectedData = [];
@wire(getConversationsByUser)
conversations( { data, error}){
    if(data){

      this.conversationList = data.map(element => Object.assign({
            "Id": element.Id,
            "LeadName": (element.Lead === undefined) ? '' : element.Lead.FirstName + ' ' +  element.Lead.LastName,
            "ContactName": (element.EndUserContact === undefined) ? '' : element.EndUserContact.FirstName + ' ' + element.EndUserContact.LastName,
            "AccountName": (element.EndUserAccount === undefined) ? '' : element.EndUserAccount.Name,
            "Status": element.Status
          })
        );
        console.log('conversationObj = ', this.conversationList);
        
    }
    if(error){
        console.log('error: ' + JSON.stringify(error));
    }
  }

  sendResponseToConversation(){
    createPendingServiceRouting({lstConversatios : this.selectedData})
    .then(result => {
        console.log('result: ' + JSON.stringify(result));
    }).catch(error => {
        console.log('error: ' + JSON.stringify(error));
    });
  }

  handleRowSelection(event){
    switch (event.detail.config.action) {
      case 'selectAllRows':
        for (let i = 0; i < event.detail.selectedRows.length; i++) {
          console.log('event.detail.selectedRows[i] = ', event.detail.selectedRows[i]);
          this.selectedData.push(event.detail.selectedRows[i]);
        }
        break;
      case 'deselectAllRows':
        this.selectedData = [];
        break;
      case 'rowSelect':
        
        event.detail.selectedRows.forEach((selectedRow) => {
          console.log('selectedRow = ', selectedRow);

          this.selectedData.push(selectedRow);
        });
        break;
      case 'rowDeselect':
        this.selectedData = this.selectedData.filter(function (e) {
          return e !== event.detail.config.value;
        });
        break;
      default:
        break;
    }
  }


 @api handleWorkAccepted(workItemId){
    console.log('conversationList = ', JSON.stringify(this.conversationList));
    this.conversationList = this.conversationList.filter((element) => {
      if(element.Id.search(workItemId) === -1){
        return element;
      }
    });

    console.log('conversationList = ', JSON.stringify(this.conversationList));
  }
}