class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    benchmark
    true
  end
  
  def benchmark
    @post = Post.new(title: "Hello World")
    
    @times = []
    sum = 0
    min = [0, 9999]
    max = [0, -1]
    
    (0..20).each do |n|
      run_benchmark(n)
    end
    
    @times.each do |t|
      sum += t[1]
      if t[1] < min[1]
        min = t
      end
      if t[1] > max[1]
        max = t
      end
    end
    average = sum / @times.length.to_f
    
    Loco.debug("Min: #{min} Max: #{max} Average: #{average}")
  end
  
  def run_benchmark(count)
    Loco.debug("Start: #{count}")
    
    start_time = Time.now
    
    posts = []
    
    (0..1000).each do |n|
      new_post = Post.new
      Loco.bind(new_post, :title).to(@post, :title)
      posts << new_post
    end
    
    @post.set(:title, "Hello World #{count}")
    
    posts.each do |post|
      post.dealloc
    end
    
    time = Time.now - start_time
    
    Loco.debug("End: #{count}: #{time}")
    
    @times << [count, time]
  end
end
