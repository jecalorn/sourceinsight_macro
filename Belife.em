
/********************************************************************
			ȡ��ϵͳ����
********************************************************************/
macro GetCurDataTime ( )
{
	var szTime
	var sz

	szTime = GetSysTime ( 1 )

	if (szTime.Month < 10)
		szTime.Month = 0 # szTime.Month;
	if (szTime.Day < 10)
		szTime.Day = 0 # szTime.Day;
	if (szTime.Hour < 10)
		szTime.Hour = 0 # szTime.Hour;
	if (szTime.Minute < 10)
		szTime.Minute = 0 # szTime.Minute;
	sz = szTime.Year # "-" # szTime.Month # "-" # szTime.Day 
//	# ", "
//		# szTime.Hour # ":" # szTime.Minute

	return sz
}


/********************************************************************
			�ж��ַ���s���Ƿ����ַ�ch.
********************************************************************/
macro IchInString(s, ch)
{
    i = 0
    cch = strlen(s)
    while (i < cch)
        {
        if (s[i] == ch)
            return i
        i = i + 1
        }

    return (0-1)
}



/********************************************************************
			�ж��ַ���source���Ƿ�������ַ���target.
********************************************************************/
macro FindString ( source, target )
{
	var source_len
	var target_len
	var match
	var cp
	var k
	var j

	source_len = strlen ( source )
	target_len = strlen ( target )

	match = 0
	cp = 0

	while( cp < source_len )
	{
		while( cp < source_len )
		{
			if( source[cp] == target[0] )
				break
			else
				cp = cp + 1
		}

		if( cp == source_len )
			break;

		k = cp
		j = 0
		while( j < target_len && source[k] == target[j] )
		{
			k = k + 1
			j = j + 1
		}

		if (j == target_len)
		{
			match = 1
			break
		}

		cp = cp + 1
	}

	if( match )
		return cp
	else
		return "X"
}


/********************************************************************
			�����ַ���ch���ַ���str�г��ֵĴ�����
********************************************************************/

Macro Find_times_occured(str, ch)
{
    var i
    var cch
	var result

    i = 0
	result = 0
    cch = strlen(str)
    while (i < cch)
    {
	    if (str[i] == ch)
	    {
	    	result = result + 1
	    }
	    i = i + 1
    }

    return (result)
}




/********************************************************************
			��ѡ�е�����ע�͵�
********************************************************************/
macro CommentBlock ( )
{
	var hwnd
	var hbuf
	var sel

	var ln
	var hit
	var len

	var cur_line

	// get window, sel, and buffer handles
	hwnd = GetCurrentWnd ( )
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )
	sel = GetWndSel ( hwnd )
	ln = sel.lnFirst

	if ( ln == sel.lnLast )
	{
		cur_line = cat ( "//", GetBufLine ( hbuf, ln ) )
		DelBufLine ( hbuf, ln )
		InsBufLine ( hbuf, ln, cur_line )
		SetBufIns ( hbuf, ln, sel.ichLim + 2 );
		stop
	}

	hit = 0

	while ( ln <= sel.lnLast )
	{
		cur_line = GetBufLine ( hbuf, ln )
		len = strlen ( cur_line )
		if ( len > 0 )
		{
			cur_line = cat ( "//", cur_line )
			DelBufLine ( hbuf, ln )
			InsBufLine ( hbuf, ln, cur_line )
			hit = 1
		}
		ln = ln + 1
	}

	// Not perfect, but this work most of the time
	if ( hit == 1 )
	{
		sel.ichFirst = 0
		sel.ichLim = sel.ichLim + 2
	}

	SetWndSel ( hwnd, sel )
}

/********************************************************************
			��ѡ�е�ע��ȡ��
********************************************************************/
macro UncommentBlock ( )
{
	var hwnd
	var hbuf
	var sel

	var ln
	var hit
	var len

	var cur_line
	var new_line

	// get window, sel, and buffer handles
	hwnd = GetCurrentWnd ( )
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )
	sel = GetWndSel ( hwnd )
	ln = sel.lnFirst

	if ( ln == sel.lnLast )
	{
		cur_line = GetBufLine ( hbuf, ln )
		len = strlen ( cur_line )
		if ( len > 0 )
		{
			if ( ( cur_line[0] == "/" ) && ( cur_line[1] == "/" ) )
			{
				new_line = strmid ( cur_line, 2, len )
				DelBufLine ( hbuf, ln )
				InsBufLine ( hbuf, ln, new_line )
				SetBufIns ( hbuf, ln, sel.ichLim - 2 )
			}
		}
		stop
	}

	hit = 0

	while ( ln <= sel.lnLast )
	{
		cur_line = GetBufLine ( hbuf, ln )
		len = strlen ( cur_line )
		if ( len > 0 )
		{
			if ( ( cur_line[0] == "/" ) && ( cur_line[1] == "/" ) )
			{
				new_line = strmid ( cur_line, 2, len )
				DelBufLine ( hbuf, ln )
				InsBufLine ( hbuf, ln, new_line )
				hit = 1
			}
		}
		ln = ln + 1
	}

	// Not perfect, but this work most of the time
	if (hit == 1)
	{
		sel.ichLim = sel.ichLim - 2
	}
	SetWndSel ( hwnd, sel )
}

/********************************************************************
			ɾ�����ļ��еĿ��У�ע�⣬��Ҫ���ִ��
********************************************************************/
Macro Delete_blank_line()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	
	hwnd = GetCurrentWnd ( )//ȡ�õ�ǰ����
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//ȡ�õ�ǰ�ļ�����

	Blank_Line_Down

	Delete_Line
	
	Top_of_File

	stop
}

/********************************************************************
			��ǰλ�ò���һ��ע�ͷָ���
********************************************************************/
macro Add_Line_comment()
{
	var hwnd
	var hbuf
	var ln
	var input
	var str_len
	var len
	var str

    hwnd = GetCurrentWnd( )     // ȡ�õ�ǰ����
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // ȡ�õ�ǰ�ļ�����

	ln = GetWndSelLnFirst (hwnd)	//ȡ�õ�ǰ���к�

	input = ask("0-ͷ�ļ�����; 1-�ⲿ��������; 2-�ڲ���������; 3-ȫ�����ݶ���; 4-�ⲿ��������; 5-��������; 6-���ݽṹ����; 7-����")

	if(input == 0)
	{
		input = "ͷ�ļ�����"
	}
	else if(input == 1)
	{
		input = "�ⲿ��������"
	}
	else if(input == 2)
	{
		input = "�ڲ���������"	
	}
	else if(input == 3)
	{
		input = "ȫ�����ݶ���"	
	}
	else if(input == 4)
	{
		input = "�ⲿ��������"	
	}
	else if(input == 5)
	{
		input = "��������"	
	}
	else if(input == 6)
	{
		input = "���ݽṹ����"	
	}
	else if(input == 7)
	{
		input = ask("����")
	}


	len = strlen(input)

	str_len = 80 - len

	str_len = str_len - 18

	str	= ""
	while(str_len > 1)
	{
		str = str # "-"
		str_len = str_len -1
	}

	Insert_Line SetBufSelText ( hbuf, "/*--------------" # input # str # "*/")

	stop

}

/********************************************************************
			�����ͣ���ں�����������ˢ������ͺ���ͷע��
********************************************************************/
macro Creat_function()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var ln				//�к�
	var sz_func_name	//���������ַ���
	var cch				//�ַ�
	var ch
	var sz_text			//�ַ���
	var index			//����
	var module_name		//ģ������
	var layer_name		//�������
	var len				//�ַ�������
	var lnFirst
	var all_name		//������ȫ��

	
	hwnd = GetCurrentWnd ( )//ȡ�õ�ǰ����
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//ȡ�õ�ǰ�ļ�����


	ln = GetWndSelLnFirst (hwnd)	//ȡ�õ�ǰ���к�

	cch='('						

	sz_text=GetBufLine(hbuf,ln)	//ȡ�õ�ǰ������
	all_name = sz_text
	len = strlen(sz_text)
	sz_text = strmid(sz_text, 4 ,len)//ȥ�� int RT

	//ȡ�ú�������
	index=0
	ch=sz_text[index]
	while(ch!="(")
	{
		index=index+1
		ch=sz_text[index]
	}
	sz_func_name=strtrunc (sz_text,index)	//ȡ�ú�����
	module_name=strtrunc(sz_text,2)	//ȡ��ģ����

	module_name = toupper(module_name)


	index=0
	ch=sz_text[index]
	while(ch!="_")
	{
		index=index+1
		ch=sz_text[index]
	}
	layer_name= strtrunc (sz_text,index)	//ȡ�ò����
	layer_name = toupper(layer_name)
	
	Insert_Line SetBufSelText ( hbuf, "/********************************************************************")
	Insert_Line_Before_Next SetBufSelText ( hbuf, "*ͷ�ļ�:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <RT4A_types.h> <RT4T_types.h> <RTMC.h> <" # layer_name # ".h>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*����ԭ��:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            "# all_name)
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*�������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*�������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*�������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*����ֵ:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            - OK")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*��������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*���ݽṹ:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*ǰ������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*��������:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "*α����:")	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "            <��>")
	Insert_Line_Before_Next Indent_Left Indent_Left Indent_Left SetBufSelText ( hbuf, "********************************************************************/")	

	Cursor_Down			//�������һ��


	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    int error_code = OK;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "int link_error[2] = {0, 0};")	

	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *func_name = \"" # sz_func_name # "\";")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *error_str = NULL;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *infor_str = NULL;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *RTER_name = NULL;")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "char *RTER_text = NULL;")


	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "/*��ڲ�������*/")

	Insert_Line_Before_Next SetBufSelText ( hbuf, "if("# layer_name # "_TRACING_IS_ON == SMEE_TRUE)")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")
	
	Insert_Line_Before_Next Indent_Right SetBufSelText ( hbuf, "RTSPDB_TR_trace(func_name, RTSPDB_TRACE_IN, \">()\");")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")


	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    ")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "/*���ڲ�������*/")
	Insert_Line_Before_Next SetBufSelText ( hbuf, "if("# layer_name # "_TRACING_IS_ON == SMEE_TRUE)")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")


	Insert_Line_Before_Next Indent_Right SetBufSelText ( hbuf, "error_str = \"OK\";")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "if(error_code != 0)")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	
	Insert_Line_Before_Next Indent_Right SetBufSelText ( hbuf, "error_str = \"ERROR\";")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")


	
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "RTSPDB_TR_trace(func_name, RTSPDB_TRACE_OUT, \"<()=%s\",error_str);")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")
	
	Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "return error_code;")
	
	Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")

	stop	

}

/********************************************************************
			���ļ��Ķ���ˢ���ļ�ͷ˵��
********************************************************************/
macro Creat_file_head()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var ln				//�к�
	var sz_func_name	//���������ַ���
	var cch				//�ַ�
	var ch
	var sz_text			//�ַ���
	var index			//����
	var module_name		//ģ������
	var file_name		//�ļ�����
	var len				//�ַ�������
	var cc_name			//�������
	var lnFirst
	var all_name		//������ȫ��
	var time			// ��ǰʱ��

	
	hwnd = GetCurrentWnd ( )//ȡ�õ�ǰ����
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//ȡ�õ�ǰ�ļ�����

	file_name = GetBufName (hbuf) //ȡ���ļ�����


	//ȡ���������
	index=strlen(file_name)
	ch=file_name[index]
	while(ch!="\\")
	{
		index=index-1
		ch=file_name[index]
	}
	index = index + 1
	len = strlen(file_name)
	file_name = strmid(file_name, index , len)

	index=0
	ch=file_name[index]
	while(ch!=".")
	{
		index=index+1
		ch=file_name[index]
	}
	
	
	cc_name=strtrunc(file_name,2)	//ȡ��ģ����

	module_name=strtrunc (file_name,index)	//ȡ��ģ��
	time = GetCurDataTime()


	ln = 0
	InsBufLine ( hbuf, ln, "/**************************************************************************" )
	InsBufLine ( hbuf, ln + 1, "* Copyright (C) 2000--2100, " )
	InsBufLine ( hbuf, ln + 2, "* All rights reserved." )
	InsBufLine ( hbuf, ln + 6, "* �ļ����� : " # file_name )
	InsBufLine ( hbuf, ln + 7, "* ��Ҫ���� : ")
	InsBufLine ( hbuf, ln + 8, "* ��ʷ��¼ : " )
	InsBufLine ( hbuf, ln + 9, "* �汾    ����         ����        ����" )
	InsBufLine ( hbuf, ln + 10, "* V1.0   " # time  # "    Belife      �����ļ�")	
	InsBufLine ( hbuf, ln + 11, "**************************************************************************/" )

	stop

}







/********************************************************************
			ˢ�������ļ���ifdefine
********************************************************************/
macro Creat_if_define()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var file_name		//�ļ�����
	var len
	var index


	hwnd = GetCurrentWnd ( )//ȡ�õ�ǰ����
	if ( hwnd == 0 )
		stop
	hbuf = GetCurrentBuf ( )//ȡ�õ�ǰ�ļ�����

	file_name = GetBufName (hbuf) //ȡ���ļ�����

	len = strlen(file_name) 

	msg(len);

	index = len - 1

	while(index != 0 && file_name[index] != "\\")
	{
		index = index -1
	}

	file_name = strmid(file_name, index + 1, len)

	len = strlen(file_name)

	index = 0

	while(index < len)
	{
		if(file_name[index] == ".")
		{
			file_name[index] = "_"
		}
		else
		{
			if(islower (file_name[index]))
			{
				file_name[index] = toupper (file_name[index])
			}
		}

		index = index + 1
	}

	file_name = "__" # file_name # "_"

	SetBufIns (hbuf, 0, 0)

	Insert_Line SetBufSelText(hbuf, "#ifndef " # file_name)
	Insert_Line_Before_Next SetBufSelText(hbuf, "#define " # file_name)



	SetBufIns (hbuf, GetBufLineCount (hbuf) -1, 0)
	Insert_Line_Before_Next SetBufSelText(hbuf, "#endif //end of" # file_name)

	msg(file_name);


}



