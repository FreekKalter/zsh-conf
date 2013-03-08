all: README.html

README.html : README.mk
	Markdown.pl README.mk > README.html
	echo 'vimYo = content.window.pageYOffset; vimXo = content.window.pageXOffset; BrowserReload(); content.window.scrollTo(vimXo,vimYo); repl.quit();' | \nc -w 1 localhost 4242 2>&1 > /dev/null 
