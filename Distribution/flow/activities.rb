class AcceptActivity
  extend AWS::Flow::Activities
  activity :accept1, :accept2, :accept3 do
    {
      version: "1.0",
    }
  end
  def accept1(request_id)
    puts "Accepted 1 #{request_id}."
  end
  def accept2(request_id)
    puts "Accepted 2 #{request_id}."
  end
  def accept3(request_id)
    puts "Accepted 3 #{request_id}."
    { foo: "bar" }
  end
end

class ProcessActivity
  extend AWS::Flow::Activities
  activity :process1, :process2 do
    {
      version: "1.0",
    }
  end
  def process1(request_id)
    result = rand(2)
    puts "Process 1 #{request_id}, result=#{result}."
    o = Future.new
    o.set({ message: "foo", result: result })
    o
  end

  def process2(request_id)
    puts "Process 2 #{request_id}."
    { message: "bar" }
  end
end

class DistributionActivity
  extend AWS::Flow::Activities
  activity :distribute1, :distribute2 do
    {
      version: "1.0",
    }
  end
  def distribute1(request_id)
    puts "Success: Distributed #{request_id}."
  end
  def distribute2(request_id)
    puts "Failed: Was not distributed #{request_id}."
  end
end
