READmE.html : README.mkdn
	Markdown.pl README.mkdn > README.html
	echo 'vimYo = content.window.pageYOffset; vimXo = content.window.pageXOffset; BrowserReload(); content.window.scrollTo(vimXo,vimYo); repl.quit();' | \nc -w 1 localhost 4242 2>&1 > /dev/null 
