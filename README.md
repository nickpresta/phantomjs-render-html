# phantomjs-render-html

Render HTML using PhantomJS into a PDF/GIF/JPEG/PNG.

Heavily based on [rasterize.js](https://github.com/ariya/phantomjs/blob/master/examples/rasterize.js), but with
support for named command line arguments, and content from STDIN (and output to STDOUT).

## How to use

1. Install PhantomJS (tested with 1.9.2). See: [http://phantomjs.org](http://phantomjs.org/)
2. `phantomjs ./render.coffee help`

## How to build PhantomJS with WOFF (Web Font) Support

Install the dependencies from [http://phantomjs.org/build.html](http://phantomjs.org/build.html) for your platform.

Check out PhantomJS:

	git clone git://github.com/ariya/phantomjs.git
	cd phantomjs
	
We need to patch PhantomJS using a forked library:

	git remote add vital https://github.com/Vitallium/phantomjs.git 
	git fetch vital
	git checkout -b fix-WOFF-file-support vital/fix-WOFF-file-support

Merge in the upstream changes from PhantomJS on top of this 'patch'.
Use the 1.9.2 tag (the latest release), or master, etc.
	
	git merge origin/1.9.2
	
Then build it!

	./build.sh
	
This takes a long time - inside my VM it took 45 minutes - so go grab lunch or something.

### What do do now?

You now have a `phantomjs` binary inside the `bin` folder of your current directory.
It is statically linked and has no runtime dependencies. Move it to correct location and then
run `./phantomjs --version` to verify your build.

### When to upgrade

When PhantomJS 2.0 is released (sometime in Spring 2014), we should use it in place of this patched version,
because it will contain the web font fixes as well as a new WebKit.
