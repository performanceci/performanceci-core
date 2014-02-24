module ResultsOverviewHelper
  def format_percent(perc)
    perc ? (perc * 100).round(2) : ''
  end

  def format_float(num)
    num ? num.round(2) : ''
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