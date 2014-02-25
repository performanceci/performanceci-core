module ResultsOverviewHelper
  def format_percent(perc)
    perc ? (perc * 100).round(2) : ''
  end

  def format_response_time(num)
    num ? (num * 1000).round(0) : ''
  end

  def thumbs(change)
    if change
      if change < 0
        "<span style='color: red'><i class='fa fa-thumbs-up fa-fw'></i>#{change.abs} %</span>"
      else
        "<span style='color: red'><i class='fa fa-thumbs-down fa-fw'></i>#{change.abs} %</span>"
      end
    else
      ''
    end
  end

  def build_panel_css
    if @build
      case @build.build_status
      when 'success'
        "panel-success"
      when 'warn'
        "panel-warning"
      when 'error'
        "panel-danger"
      when 'failed'
        "panel-danger"
      else
        ''
      end
    else
      ""
    end
  end
end