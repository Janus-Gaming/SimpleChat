
///////////
// CONST //
///////////

var/const

	CODE_LIFE		= 18000

	CODE_FG			= "#FFFFFF"
	CODE_BG			= "#000000"
	CODE_NUMBER		= "#FF8800"
	CODE_STRING		= "#0088FF"
	CODE_PREPROC	= "#FFFF00"
	CODE_KEYWORD	= "#0000FF"
	CODE_COMMENT	= "#00FF00"
	CODE_LINENUM	= "#666666"

/////////////////
// CODE OBJECT //
/////////////////

code

/////////
// VAR //
/////////

code/var

	id					= ""
	creator				= ""
	raw_text			= ""
	html_text			= ""
	life				= CODE_LIFE

	timer/
		update_timer	= new(10,-1)

//////////
// PROC //
//////////

code/proc



	SetCreator(T)
		creator	= T

	SetRawText(T)
		raw_text = ParseTabs(CropText(html_encode(T),5000))
		SetHTMLText()

	SetHTMLText()
		if (raw_text)
			html_text = \
{"
<html>
	<body>
		<font face=\"Consolas\" color=\"#000000\"><b>
		<pre style=\"tab-size:4\">[raw_text]</pre>
		</b></font>
	</body>
</html>
"}


/////////
// NEW //
/////////

code/New()
	..()
	id 		= num2text(world.timeofday)
	_codes 	+= src
	return 	src

/////////
// DEL //
/////////

code/Del()
	_codes -= src
	..()



////////////
// UPDATE //
////////////

code/Update()

	update_timer.Update()
	if (update_timer.Event_TimeUp())
		life -= 1
		if (life <= 0)
			del src
