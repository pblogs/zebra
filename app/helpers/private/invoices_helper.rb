module Private::InvoicesHelper
  def invoice_status(inv)
    if inv.due_date.present?
      show_due_date(inv)
    else
      content_tag :span, class: Invoice::STATUS[inv.status].downcase do
        Invoice::STATUS[inv.status].upcase
      end
    end
  end

  def show_due_date(inv)
    if inv.due_date == Date.today
      message = "DUE TODAY"
      css = 'open'
    elsif inv.due_date > Date.today
      number_of_days = (inv.due_date - Date.today).to_i
      message = "DUE IN #{pluralize(number_of_days, 'day').upcase}"
      css = 'open'
    elsif inv.due_date < Date.today
      number_of_days = (Date.today - inv.due_date).to_i
      message = "OVERDUE BY #{pluralize(number_of_days, 'day').upcase}"
      css = 'overdue'
    end

    content_tag :span, class: css do
      message
    end
  end
end
