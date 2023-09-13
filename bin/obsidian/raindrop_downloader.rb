#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require "json"
require "yaml"
require "active_support/all"
Bundler.require(:default)
Dotenv.load

class Raindrop
  attr_accessor :token

  def initialize(token)
    @token = token
  end

  def collections
    get("/collections/all")["items"]
  end

  def parse(url)
    get("/import/url/parse", url: url)["item"]
  end

  def raindrops(search = nil)
    drops = []
    page = 0
    query = { page: page }
    query[:search] = search if search
    loop do
      resp = get("/raindrops/0", query)
      drops = drops.concat(resp["items"])
      break if resp["items"] == [] 
      page +=1
      query[:page] = page
    end
    drops
  end

  def liked
    raindrops("#💖")
  end

  def get(path, query = nil)
    JSON.parse(client.get(path: base_path + path, query: query).body)
  end

  def base_path
    "/rest/v1"
  end

  def client
    @client ||= Excon.new("https://api.raindrop.io/", headers: { "Authorization" => "Bearer #{token}" })
  end
end

class Downloader
  def download_liked
    raindrop.liked.each do |l|
      data = {
        uuid: l["_id"],
        bookmarkOf: l["link"],
        category: l["type"],
        headImage: l["cover"],
        title: l["title"],
        description: l["excerpt"],
        tags: l.dig("meta", "tags"),
        date: l["created"],
      }
    end
  end


  def to_frontmatter(l)
    {
      "uuid" => l["_id"],
      "bookmarkOf" => l["link"],
      "category" => l["type"],
      "headImage" => l["cover"],
      "title" => l["title"],
      "description" => l["excerpt"],
      "tags" => l.dig("meta", "tags"),
      "date" => l["created"],
    }
  end

  def download_all
    all = raindrop.collections
    drops = raindrop.raindrops
    drops.each do |d|
    end
    all.each do |c|
      c["raindrops"] = drops.select { |d| d.dig("collection", "$id") == c["_id"] }
    end
    root = all.select { |c| c["parent"].nil? }
    root.each do |p|
      p["children"] = all.select { |c| c.dig("parent", "$id") == p["_id"] }
    end
    root.each do |c|
      path = "#{destination}/#{c["title"]}"
      Dir.mkdir path unless File.exist?(path)
      c["raindrops"].each do |r|
        r = r.merge(raindrop.parse(r["link"]))
        md = to_md(r)
        filename = r["title"].parameterize
        File.write("#{path}/#{filename[0..50]}-#{r["_id"]}.md", md)
      end
      c["children"].each do |k|
        path = path + "/" + k["title"]
        Dir.mkdir path unless File.exist?(path)
        k["raindrops"].each do |r|
          r = r.merge(raindrop.parse(r["link"]))
          md = to_md(r)
          filename = r["title"].parameterize
          File.write("#{path}/#{filename[0..50]}-#{r["_id"]}.md", md)
        end
      end
    end
  end

  def to_md(r)
    header = (r["type"] == "video") ? "[#{r["domain"]}](#{r["link"]})" : "![](#{r["_id"]}.webp)"
    domain = (r["type"] == "video") ? r["domain"] : "[#{r["domain"]}](#{r["link"]})"
    ht = ""
    if r["highlights"].any?
      ht = "## Highlights\n" + r["highlights"].map {|h| h["text"] }.join("\n")
    end
    file = <<~MD
    ---
    #{header}
    
    # #{r["title"]}
    #{domain}

    #{r["excerpt"]}

    #{r["ht"]}
    MD
    YAML.dump(to_frontmatter(r)) + file
  end

  def destination
    ENV["DESTINATION"]
  end

  def raindrop
    @raindrop ||= Raindrop.new(ENV["RAINDROP_TOKEN"])
  end
end

Downloader.new.download_all