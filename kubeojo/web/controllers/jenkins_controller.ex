defmodule Kubeojo.JenkinsController do
  use Kubeojo.Web, :controller
   @root_dir File.cwd!()

  def index(conn, _params) do
    # get jobnames
    jobnames = Kubeojo.Yaml.jenkins_jobs()
    render conn, "index.html", jenkins: jobnames
  end
  
  def show(conn, %{"jobname" => jobname}) do
    data = Kubeojo.Jenkins.Analyze.testfailures_pro_jobname(jobname)
    csv_file = "#{@root_dir}/priv/static/js/flare.csv"
    File.write(csv_file, "title,category,views\n") 
    Enum.each(data, fn{test_name, failure} ->
      File.write(csv_file, "#{test_name},#{failure},#{failure}\n", [:append]) 
    end)
    render conn, "show.html", failures: data, jobname: jobname
  end
end
