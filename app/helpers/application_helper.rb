module ApplicationHelper

  def icon_for_status(status)
    case status
    when 'success'
      '<i class="fa fa-check fa-fw" style="color:green"></i>'
    when 'warn'
      '<i class="fa fa-warning fa-fw" style="color:orange"></i>'
    when 'error'
      '<i class="fa fa-warning fa-fw" style="color:red"></i>'
    when 'failed'
      '<i class="fa fa-warning fa-fw" style="color:red"></i>'
    else
      ''
    end
  end
end
