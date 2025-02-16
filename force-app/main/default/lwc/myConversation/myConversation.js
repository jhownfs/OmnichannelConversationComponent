import { LightningElement, api, track } from 'lwc';
import getConversationsByUser from '@salesforce/apex/ConversationController.getConversationsByUser';
import createPendingServiceRouting from '@salesforce/apex/ConversationController.createPendingServiceRouting'
import successMsg from '@salesforce/label/c.save_success_msg'
import errorMsg from '@salesforce/label/c.error_success_msg'
import refreshMsg from '@salesforce/label/c.refresh_msg'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

const columns = [
  { label: 'Lead', fieldName: 'LeadName', type: 'text' },
  { label: 'Contato', fieldName: 'ContactName', type: 'text'},
  { label: 'Conta', fieldName: 'AccountName', type: 'text'},
  { label: 'Status', fieldName: 'Status', type: 'text'}
];

export default class MyConversation extends LightningElement {

@track conversationList = [];
columns = columns;
@track showSpinner = false;
selectedData = [];

connectedCallback(){
  this.showSpinner = true;
  this.getConversations();
}

async getConversations(){
  try {
    const response = await getConversationsByUser();
    this.conversationList = response.map(element => Object.assign({
          "Id": element.Id,
          "LeadName": (element.Lead === undefined) ? '' : element.Lead.FirstName + ' ' +  element.Lead.LastName,
          "ContactName": (element.EndUserContact === undefined) ? '' : element.EndUserContact.FirstName + ' ' + element.EndUserContact.LastName,
          "AccountName": (element.EndUserAccount === undefined) ? '' : element.EndUserAccount.Name,
          "Status": element.Status
        })
      )
    if(response){
      this.showSpinner = false;
    }
  } catch (error) {
    this.handleMsg('Error', errorMsg, 'error');
  }
}

  async sendResponseToConversation(){
    try {
    const result = await createPendingServiceRouting({Conversations : this.selectedData});
    if(result){
      this.handleMsg('Success', successMsg, 'success');
    } 
   } catch (error) {
    this.handleMsg('Error', errorMsg, 'error');
   }
  }

  handleRowSelection(event){
    switch (event.detail.config.action) {
      case 'selectAllRows':
        for (let i = 0; i < event.detail.selectedRows.length; i++) {
          this.selectedData.push(event.detail.selectedRows[i]);
        }
        break;
      case 'deselectAllRows':
        this.selectedData = [];
        break;
      case 'rowSelect':
        event.detail.selectedRows.forEach((selectedRow) => {
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
    this.conversationList = this.conversationList.filter((element) => {
      if(element.Id.search(workItemId) === -1){
        return element;
      }
    });
  }

  @api async handleLogout(){
    this.getConversations();
    this.handleMsg('Success', refreshMsg, 'success');
  }

  handleRefreshValues(){
    this.showSpinner = true;
    this.conversationList = [];
    this.handleLogout();
  }

  handleMsg(title, message, variant) {
    const evt = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
    });
    this.dispatchEvent(evt);
  }
}