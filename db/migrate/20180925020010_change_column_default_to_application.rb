class ChangeColumnDefaultToApplication < ActiveRecord::Migration[5.2]
  def change
    change_column :applications, :last_mail_sent, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
