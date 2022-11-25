import { LightningElement } from 'lwc';
import getAggregatedUnpublishedNotifications from '@salesforce/apex/UN_UsernotificationStatusController.getAggregatedUnpublishedNotifications';
import getAggregatedUnpublishedDoneNotifications from '@salesforce/apex/UN_UsernotificationStatusController.getAggregatedUnpublishedDoneNotifications';
import findRunningRepublishBatches from '@salesforce/apex/UN_UsernotificationStatusController.findRunningRepublishBatches';
import republishUnsentNotifications from '@salesforce/apex/UN_UsernotificationStatusController.republishUnsentNotifications';
import republishDoneNotifications from '@salesforce/apex/UN_UsernotificationStatusController.republishDoneNotifications';

export default class UN_UsernotificationStatus extends LightningElement {
    _pollingActivated = false;
    refreshIntervalInSeconds = 60;
    lastSync;
    fromDate = null;
    timeoutId = null;
    aggregatedUnpublishedNotifications = [];
    aggregatedUnpublishedDoneNotifications = [];
    runningRepublishBatches = [];
    syncingGetAggregatedUnpublishedNotifications = false;
    syncingGetAggregatedUnpublishedDoneNotifications = false;
    runningFindRunningRepublishBatches = false;

    set pollingActivated(value) {
        if (false === (this._pollingActivated === value)) {
            this._pollingActivated = value;
            if (this._pollingActivated === true) {
                this.refreshAll();
            } else {
                this.abortPolling();
            }
        }
    }

    get pollingActivated() {
        return this._pollingActivated;
    }

    get aggregatedColumns() {
        return [
            { label: 'Date', fieldName: 'day', type: 'date' },
            { label: 'Hour', fieldName: 'hour', type: 'number' },
            { label: 'Number', fieldName: 'count', type: 'number' }
        ];
    }

    get hasAggregatedUnpublishedNotifications() {
        return (
            Array.isArray(this.aggregatedUnpublishedNotifications) && this.aggregatedUnpublishedNotifications.length > 0
        );
    }

    get hasAggregatedUnpublishedDoneNotifications() {
        return (
            Array.isArray(this.aggregatedUnpublishedDoneNotifications) &&
            this.aggregatedUnpublishedDoneNotifications.length > 0
        );
    }

    get hasRunningRepublishBatches() {
        return Array.isArray(this.runningRepublishBatches) && this.runningRepublishBatches.length > 0;
    }

    connectedCallback() {
        this.setDefaultFromDate();
        this.tooglePolling();
    }

    runGetAggregatedUnpublishedNotifications() {
        this.syncingGetAggregatedUnpublishedNotifications = true;
        getAggregatedUnpublishedNotifications({ fromDate: this.fromDate })
            .then((result) => {
                this.aggregatedUnpublishedNotifications = result;
            })
            .catch((error) => {
                console.error(error);
                this.aggregatedUnpublishedNotifications = [];
            })
            .finally(() => {
                this.syncingGetAggregatedUnpublishedNotifications = false;
            });
    }

    runGetAggregatedUnpublishedDoneNotifications() {
        this.syncingGetAggregatedUnpublishedDoneNotifications = true;
        getAggregatedUnpublishedDoneNotifications({ fromDate: this.fromDate })
            .then((result) => {
                this.aggregatedUnpublishedDoneNotifications = result;
            })
            .catch((error) => {
                console.error(error);
                this.aggregatedUnpublishedDoneNotifications = [];
            })
            .finally(() => {
                this.syncingGetAggregatedUnpublishedDoneNotifications = false;
            });
    }

    runFindRunningRepublishBatches() {
        this.runningFindRunningRepublishBatches = true;
        findRunningRepublishBatches()
            .then((result) => {
                this.runningRepublishBatches = result;
            })
            .catch((error) => {
                console.error(error);
                this.runningRepublishBatches = [];
            })
            .finally(() => {
                this.runningFindRunningRepublishBatches = true;
            });
    }

    runRepublishUnsentNotifications() {
        republishUnsentNotifications().then(() => {
            this.runFindRunningRepublishBatches();
        });
    }

    runRepublishDoneNotifications() {
        republishDoneNotifications().then(() => {
            this.runFindRunningRepublishBatches();
        });
    }

    tooglePolling() {
        this.pollingActivated = !this.pollingActivated;
    }

    setDefaultFromDate() {
        const now = new Date();
        this.fromDate = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];
    }

    refreshAll() {
        this.runFindRunningRepublishBatches();
        this.runGetAggregatedUnpublishedNotifications();
        this.runGetAggregatedUnpublishedDoneNotifications();
        this.lastSync = new Date().toISOString();
        if (this.pollingActivated === true) {
            this.pollData();
        }
    }

    pollData() {
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.timeoutId = setTimeout(() => {
            this.refreshAll();
        }, this.refreshIntervalInSeconds * 1000);
    }

    abortPolling() {
        clearTimeout(this.timeoutId);
        this.timeoutId = null;
    }

    handleDateChange(event) {
        this.fromDate = event.target.value;
        if (this.pollingActivated === false) {
            this.refreshAll();
        }
    }
}
