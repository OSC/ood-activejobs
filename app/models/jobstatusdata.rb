# Model for view data from PBS-Ruby response.
#
# The PBS-Ruby results are much larger than this app needs them to be
# so this model extracts the necessary info to send to the user.
#
# @author Brian L. McMichael
# @version 0.0.1
class Jobstatusdata

  attr_reader :pbsid, :jobname, :username, :status, :cluster, :nodes, :starttime

  # Set the object to the server.
  #
  # @return [Jobstatusdata] self
  def initialize(pbs_job)
    self.pbsid = pbs_job[:name]
    self.jobname = pbs_job[:attribs][:Job_Name]
    self.username = username(pbs_job[:attribs][:Job_Owner])
    self.status = pbs_job[:attribs][:job_state]
    if self.status == "R"
      self.nodes = node_array(pbs_job[:attribs][:exec_host])
      self.starttime = pbs_job[:attribs][:start_time]
    end
    self.cluster = hostname(pbs_job[:attribs][:submit_host])
    self
  end

  def username(attribs_Job_Owner)
    attribs_Job_Owner.split('@')[0]
  end

  def node_array(attribs_exec_host)
    nodes = Array.new
    attribs_exec_host.split('+').each do |node|
      nodes.push(node.split('/')[0])
    end
    nodes
  end

  def hostname(attribs_submit_host)
    #attribs_submit_host.split(/\d+/)[0]

    # We may want to split after the number.
    # PBS returns jobs running  on Websvcs and N000 nodes,
    # and the above line cuts the digits and not the number.
    # Additional handling will be necessary if we want
    # to avoid displaying 'oakley02', 'ruby01', etc.
    attribs_submit_host.split('.')[0]
  end

  private

    attr_writer :pbsid, :jobname, :username, :status, :cluster, :nodes, :starttime

end