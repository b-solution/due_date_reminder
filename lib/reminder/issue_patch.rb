module Reminder
  module IssuePatch
    def self.included(base)
      base.send(:include, InstanceMethods)
    end
  end

  module InstanceMethods
    def days_before_due_date
      (due_date - Date.today).to_i
    end

    def remind?
      if !assigned_to.nil? and assigned_to.is_a?(User)
          return assigned_to.reminder_notification_array.include?(days_before_due_date)
      end
      false
    end
  end
end
unless Issue.included_modules.include? Reminder::IssuePatch
  Issue.send(:include, Reminder::IssuePatch)
end