# Written by Nick Presta (nick@nickpresta.ca)
# Released under the MIT license.
# See: https://github.com/NickPresta/phantomjs-render-html
page = require('webpage').create()
system = require 'system'

usage = ->
  console.log '''Usage: rasterize.coffee -url URL -paper [paperwidth*paperheight|paperformat] -format pdf -output output [< stdin]
  Examples:
    phantomjs rasterize.coffee -url http://google.com -output /dev/stdout
    phantomjs rasterize.coffee -output /dev/stdout < myfile.html
    phantomjs rasterize.coffee -url http://google.com -paper letter -output out.pdf
  Argument types:
    url: local (file:///foobar.html), internet (http://google.com)
    paper: 5in*7.5in, 10cm*20cm, A4, Letter
    output: out.pdf, out.png, /dev/stdout
    stdin: a file or string (standard unix redirection)'''
  phantom.exit 1

optionParser = ->
  if phantom.args.length < 1
    usage()

  opts = {}
  opt = 0
  while opt < phantom.args.length and phantom.args[opt][0] is '-'
    option = phantom.args[opt]
    switch(option)
      when '-url'
        opts.url = phantom.args[++opt]
      when '-paper'
        opts.paper = phantom.args[++opt]
      when '-format'
        opts.format = phantom.args[++opt]
      when '-output'
        opts.output = phantom.args[++opt]
      when '-help'
        usage()
      else
        console.log "Unknown switch: #{phantom.args[opt]}"
        usage()
    opt++
  return opts

render = (status, opts) ->
  if status isnt 'success'
    console.log 'Unable to load the content!'
    phantom.exit 1
  else
    window.setTimeout (-> page.render(opts.output, {format: opts.format}); phantom.exit()), 1000

opts = optionParser()

unless opts.output
  usage()
else
  # Argument checking
  unless opts.output
    console.log 'No output provided'
    phantom.exit 1

  unless opts.format
    opts.format = 'pdf'
  if opts.format not in ['png', 'pdf']
    console.log 'Invalid output format - should either be png or pdf'
    phantom.exit 1

  unless opts.paper
    opts.paper = 'Letter'
  if '*' in opts.paper
    size = opts.paper.split '*'
    if size.length is 2
      # Specified something like 5in*7.5in
      page.paperSize = {width: size[0], height: size[1], border: '0'}
  else
    # Otherwise single value (i.e. Letter)
    page.paperSize = {format: opts.paper, orientation: 'portrait', border: '1cm'}

  unless opts.url
    content = system.stdin.read()
    unless content
      console.log 'No URL or stdin provided'
      phantom.exit 1
    page.content = content

  # Run the script
  if opts.url
    page.open opts.url, (status) ->
      render status, opts
  else if page.content
    page.onLoadFinished = (status) -> render status, opts
  else
    console.log 'No URL or stdin provided'
    phantom.exit 1
