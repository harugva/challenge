import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import MessageIfNotClicked from '@salesforce/label/c.MessageIfNotClicked';
import { subscribe, publish, MessageContext } from 'lightning/messageService';
import ALL_MISSION_MESSAGE_CHANNEL from '@salesforce/messageChannel/AllMissionMessageChannel__c';
import applyMission from '@salesforce/apex/MissionDetailController.applyMission';
import completeMission from '@salesforce/apex/MissionDetailController.completeMission';
import LIGHTNING_ICON from "@salesforce/resourceUrl/Lightning_Icon";
import VECTOR_ICON from "@salesforce/resourceUrl/Vector_Icon";


export default class MissionDetails extends LightningElement {
    @api selectedMission;
    @wire(MessageContext) messageContext;
    messageIfNotClicked = MessageIfNotClicked;
    lightningIcon = LIGHTNING_ICON;
    vectorIcon = VECTOR_ICON;

    subscription;

    connectedCallback() {
        this.subscription = subscribe(
            this.messageContext,
            ALL_MISSION_MESSAGE_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    handleMessage(message) {
        this.selectedMission = message.recordData;
    }

    get showApplyButton() {
        return this.selectedMission && this.selectedMission.status === 'Available';
    }

    get showCompleteButton() {
        return this.selectedMission && this.selectedMission.status === 'In progress';
    }

    handleApplyClick() {
        applyMission({ missionWrapper: this.selectedMission })
            .then(result => {
                this.showToast('Success', 'Mission Applied', 'success');

                const payload = {
                    recordId: this.selectedMission.Id,
                    recordData: this.selectedMission
                };
                publish(this.messageContext, ALL_MISSION_MESSAGE_CHANNEL, payload);
                this.selectedMission = false;
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    handleCompleteClick() {
        completeMission({ missionWrapper: this.selectedMission })
            .then(result => {
                this.showToast('Success', 'Mission Completed', 'success');

                const payload = {
                    recordId: this.selectedMission.Id,
                    recordData: this.selectedMission
                };
                publish(this.messageContext, ALL_MISSION_MESSAGE_CHANNEL, payload);
                this.selectedMission = false;
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}