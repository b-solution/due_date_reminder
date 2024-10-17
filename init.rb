Redmine::Plugin.register :due_date_reminder do
  name 'Due Date Reminder plugin'
  author 'Oleg Kandaurov'
  description 'Sends notifications about due date'
  version '0.3.2'
  url 'https://github.com/f0y/due_date_reminder'
  author_url 'http://f0y.me'
  requires_redmine :version_or_higher => '5.0.0'
  settings :default => { 'reminder_notification' => '1,3,5' }, :partial => 'reminder/settings'
end
if Rails.configuration.respond_to?(:autoloader) && Rails.configuration.autoloader == :zeitwerk
  Rails.autoloaders.each { |loader| loader.ignore(File.dirname(__FILE__) + '/lib') }
end

require File.dirname(__FILE__) + '/lib/reminder/issue_patch'
require File.dirname(__FILE__) + '/lib/reminder/user_patch'
require File.dirname(__FILE__) + '/lib/reminder/settings_controller_patch'
require File.dirname(__FILE__) + '/lib/reminder/my_controller_patch'

class ReminderViewHook < Redmine::Hook::ViewListener
  def view_layouts_base_body_bottom(context = {})
    if context[:controller] && (context[:controller].is_a?(MyController))
      "script type='text/javascript'>
          $('#no_self_notified').parent().parent().append($('#reminder_notification'));
        </script>
      ".html_safe
    end
  end

  def view_my_account_preferences(context = {})
    "
      <p id='reminder_notification'>
        #{context[:form].text_field :reminder_notification, :required => true, :size => 10,
                                    :value                            => context[:user].reminder_notification}
        <br/>
        <em>#{label_tag 'text_comma_separated', l(:text_comma_separated)}</em>
      </p>
    ".html_safe
  end
end



