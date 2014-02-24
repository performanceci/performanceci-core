module ResultsOverviewHelper
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