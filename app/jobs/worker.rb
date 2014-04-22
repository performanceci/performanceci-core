require 'open3'

class ShellError < StandardError; end

class Worker
  def self.system_quietly(*cmd)
    exit_status=nil
    err=nil
    out=nil
    Open3.popen3(*cmd) do |stdin, stdout, stderr, wait_thread|
      err = stderr.gets(nil)
      out = stdout.gets(nil)
      [stdin, stdout, stderr].each{|stream| stream.send('close')}
      exit_status = wait_thread.value
    end
    if exit_status.to_i > 0
      err = err.chomp if err
      raise ShellError, err
    elsif out
      return out.chomp
    else
      return true
    end
  end

  def self.system_capture(cmd)
    IO.popen([*cmd, :err=>[:child, :out]]) do |io|
      result_with_error = io.read
    end
  end

end
