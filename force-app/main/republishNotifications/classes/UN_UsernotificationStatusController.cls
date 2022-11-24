public with sharing class UN_UsernotificationStatusController {
    @AuraEnabled
    public static List<AggregatedNotificationStatus> getAggregatedUnpublishedNotifications(Date fromDate) {
        List<AggregatedNotificationStatus> statuses = new List<AggregatedNotificationStatus>();
        for (AggregateResult aggr : [
            SELECT COUNT(Id) nmb, DAY_ONLY(LastModifiedDate) day, HOUR_IN_DAY(LastModifiedDate) hour
            FROM UserNotification__c
            WHERE
                LastModifiedDate >= :fromDate
                AND CRM_SuccessfullySentNotification__c = FALSE
                AND INT_Type__c = 'INNBOKS'
            GROUP BY DAY_ONLY(LastModifiedDate), HOUR_IN_DAY(LastModifiedDate)
            ORDER BY DAY_ONLY(LastModifiedDate), HOUR_IN_DAY(LastModifiedDate)
        ]) {
            statuses.add(new AggregatedNotificationStatus(aggr));
        }
        return statuses;
    }

    @AuraEnabled
    public static List<AggregatedNotificationStatus> getAggregatedUnpublishedDoneNotifications(Date fromDate) {
        List<AggregatedNotificationStatus> statuses = new List<AggregatedNotificationStatus>();
        for (AggregateResult aggr : [
            SELECT COUNT(Id) nmb, DAY_ONLY(LastModifiedDate) day, HOUR_IN_DAY(LastModifiedDate) hour
            FROM UserNotification__c
            WHERE
                LastModifiedDate >= :fromDate
                AND CRM_SuccessfullySentDone__c = FALSE
                AND CRM_Done__c = TRUE
                AND INT_Type__c = 'INNBOKS'
            GROUP BY DAY_ONLY(LastModifiedDate), HOUR_IN_DAY(LastModifiedDate)
            ORDER BY DAY_ONLY(LastModifiedDate), HOUR_IN_DAY(LastModifiedDate)
        ]) {
            statuses.add(new AggregatedNotificationStatus(aggr));
        }
        return statuses;
    }

    @AuraEnabled
    public static Id republishUnsentNotifications() {
        return new UN_RepublishUsernotificationBatch()
            .setBatchSize(1)
            .setFilter(
                'LastModifiedDate = LAST_N_DAYS:7 AND CRM_SuccessfullySentNotification__c = false AND INT_Type__c = \'INNBOKS\''
            )
            .run();
    }

    @AuraEnabled
    public static Id republishDoneNotifications() {
        return new UN_RepublishUsernotificationBatch()
            .setIsDoneNotifications()
            .setFilter(
                'LastModifiedDate = LAST_N_DAYS:7 AND CRM_SuccessfullySentDone__c = false AND CRM_Done__c = true AND INT_Type__c = \'INNBOKS\''
            )
            .run();
    }

    @AuraEnabled
    public static List<RunningBatchJob> findRunningRepublishBatches() {
        List<RunningBatchJob> runningBatchJobs = new List<RunningBatchJob>();

        for (AsyncApexJob apexJob : [
            SELECT Id, JobItemsProcessed, Status, NumberOfErrors, TotalJobItems
            FROM AsyncApexJob
            WHERE
                ApexClass.Name = 'UN_RepublishUsernotificationBatch'
                AND Status IN ('Holding', 'Preparing', 'Processing', 'Queued')
        ]) {
            runningBatchJobs.add(new RunningBatchJob(apexJob));
        }

        return runningBatchJobs;
    }

    public class RunningBatchJob {
        @AuraEnabled
        public String key { public get; private set; }
        @AuraEnabled
        public Integer totalJobItems { public get; private set; }
        @AuraEnabled
        public String status { public get; private set; }
        @AuraEnabled
        public Integer numberOfErrors { public get; private set; }
        @AuraEnabled
        public Integer jobItemsProcessed { public get; private set; }
        @AuraEnabled
        public String variant { public get; private set; }
        @AuraEnabled
        public Decimal progress { public get; private set; }

        public RunningBatchJob(AsyncApexJob apexJob) {
            this.key = apexJob.Id;
            this.totalJobItems = apexJob.TotalJobItems;
            this.status = apexJob.Status;
            this.numberOfErrors = apexJob.NumberOfErrors;
            this.jobItemsProcessed = apexJob.JobItemsProcessed;
            this.variant = this.numberOfErrors > 0 ? 'expired' : 'base-autocomplete';
            this.progress = this.totalJobItems > 0 ? (this.jobItemsProcessed / this.totalJobItems) * 100 : 0;
        }
    }

    public class AggregatedNotificationStatus {
        @AuraEnabled
        public String key { public get; private set; }
        @AuraEnabled
        public Date day { public get; private set; }
        @AuraEnabled
        public Integer hour { public get; private set; }
        @AuraEnabled
        public Integer count { public get; private set; }

        public AggregatedNotificationStatus(AggregateResult aggr) {
            this.day = (Date) aggr.get('day');
            this.hour = (Integer) aggr.get('hour');
            this.count = (Integer) aggr.get('nmb');
            this.key = this.day + '-' + this.hour;
        }
    }
}
