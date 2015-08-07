module Stores
  class ExternalAccountTransferStore < Store

    def stream_name
      '$ce-externalAccountTransfer'
    end

    def accepted_params
      [
        :id,
        :amount,
        :clabe,

        :customerId,
        :name,
        :paternalName,
        :maternalName,
        :amount,
        :referenceCode,

        :initiatedTime,
        :completedTime,
        :failureTime,
        :failureMessage
      ]
    end

    def self.configure(receiver)
      receiver.external_account_transfer_store = instance
    end

    def update_store_from_event(event)

      super(event) do |entity|
        if event.type == "Initiate"
          entity[:state] = "Pending"
        elsif event.type == "DisburseFundsInitiated"
          entity[:state] = "Disbursing"
        elsif event.type == "Failure"
          entity[:state] = "Failed"
        elsif event.type == "Successful"
          entity[:state] = "Completed"
        elsif event.type == "DisburseFundsFailed"
          entity[:state] = "Pending"
        elsif event.type == "Rollback"
          entity[:state] = "RolledBack"
        end
      end

    end

    def pending
      all.select{|l| l[:state] == "Pending" }
    end

  end
end