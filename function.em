/**************************************************************************
* Copyright (C) 2007, �Ϻ�΢����װ�����޹�˾
* All rights reserved.
* ��Ʒ�� : SS B500/10
* ������� : Struct.em
* ģ������ : Struct.em
* �ļ����� : test.em
* ��Ҫ���� : ���ļ���Ҫ�����˶Խṹ���������ز����ĺꡣ
* ��ʷ��¼ : 
* �汾    ����         ����        ����
* V1.0   2007-06-07    �ŷ�Ԫ      �����汾��
**************************************************************************/


/*--------------V1.0---------------------------------------------------------*/
//V1.0
//������ǰ�ĸ��ֺ��������������,
//1	-	�Զ�����trace
//2	-	�Զ�����data_req






/********************************************************************
*����ԭ��:
			macro FUNCTION_auto_data_req()
*����˵��:
			��
*����˵��:
			���ݺ��������Զ�����data_req���룬����ʹ��sscanf
*����ֵ:
			��
********************************************************************/
macro FUNCTION_auto_data_req()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var ln				//�к�
	var param_result		//���������������
	var sz_text
	var Result
	var ln_trace
	var trace_result
	var index
	var flag
	var str
	var cch
	var len
	var layer_name
	var ch
	var all_str
	var data_req_flag
	var input
	var ln_data_req


    hwnd = GetCurrentWnd( )     // ȡ�õ�ǰ����
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // ȡ�õ�ǰ�ļ�����

	ln = GetWndSelLnFirst (hwnd)	//ȡ�õ�ǰ���к�

	sz_text=GetBufLine(hbuf,ln)	//ȡ�õ�ǰ������

	all_str = sz_text

	cch='('						

	sz_text=GetBufLine(hbuf,ln)	//ȡ�õ�ǰ������

	len = strlen(sz_text)
	sz_text = strmid(sz_text, 4 ,len)//ȥ�� int RT

	index=0
	ch=sz_text[index]
	while(ch!="_")
	{
		index=index+1
		ch=sz_text[index]
	}
	layer_name= strtrunc (sz_text,index)	//ȡ�ò����
	layer_name = toupper(layer_name)



	//��������
	param_result = FUNCTION_parse_param(all_str)
	
	//��ӡ
	data_req_flag =1
	Result = FUNCTION_print_trace(param_result.param_buf, param_result.param_count,data_req_flag)

	Cursor_Down
//	input = ask("0- data_req,   1- scanf");

	input = 0
	if(input == 0)
	{
//		Insert_Line SetBufSelText ( hbuf, "if("# layer_name # "_DATAREQ_IS_ON == SMEE_TRUE)")
//		Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	
//		Insert_Line_Before_Next SetBufSelText ( hbuf, "    TR4A_data_request(\"RT\", TR4A_REQ_INT_OUTPUT, func_name, NULL, \"Request_Flag = %d\",&Request_Flag);")	
//		Insert_Line_Before_Next SetBufSelText ( hbuf, "if(Request_Flag != 0)")	
//		Insert_Line_Before_Next SetBufSelText ( hbuf, "{")	


	//��ӡ��������
	ln_data_req = ln + 1
	index = 0
	while(index < 30)
	{
		 
		trace_result = GetBufLine(hbuf,ln_data_req)		
//		msg trace_result
		flag = FindString(trace_result , "/*�����������*/")
//		msg flag
		if(flag != "X")	//�ҵ����trace
		{
			break;
		}
		index = index +1
		ln_data_req = ln_data_req +1 	
	}
	if(index == 30)
	{
		msg "cant't find /*�����������*/"
	}
	else
	{
		SetBufIns (hbuf, ln_data_req-1 , 0)
		Insert_Line_Before_Next SetBufSelText ( hbuf, "    /*���������������*/")			
		if(Result.input_fmt == " ")
		{

			Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    TR4A_data_request(\"RT\", TR4A_REQ_EXT_OUTPUT, func_name, NULL, """ # Result.input_fmt)			
		}
		else
		{
			Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    TR4A_data_request(\"RT\", TR4A_REQ_EXT_OUTPUT, func_name, NULL, " # Result.input_fmt)		
		}
		Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")			
	}

	ln_data_req = ln_data_req + 1
	index = 0
	while(index < 100)
	{
		trace_result = GetBufLine(hbuf,ln_data_req)		
		flag = FindString(trace_result , "/*�����������*/")
		if(flag != "X")	//�ҵ����trace
		{
			break;
		}
		index = index +1
		ln_data_req = ln_data_req +1 	
	}

	if(index == 30)
	{
		msg "cant find /*�����������*/"
	}
	else
	{
		SetBufIns (hbuf, ln_data_req-1 , 0)
		Insert_Line_Before_Next SetBufSelText ( hbuf, "    /*���������������*/")			
		if(Result.output_fmt == " ")
		{
			Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    TR4A_data_request(\"RT\", TR4A_REQ_EXT_OUTPUT, func_name, NULL, """ # Result.output_fmt)			
		}
		else
		{
			Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "    TR4A_data_request(\"RT\", TR4A_REQ_EXT_OUTPUT, func_name, NULL, " # Result.output_fmt)		
		}
		Insert_Line_Before_Next SetBufSelText ( hbuf, "    ")			
	}


//		Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")	
//		Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "}")	
	}
	else if(input == 1)
	{

		Insert_Line_Before_Next Indent_Left SetBufSelText ( hbuf, "sscanf(RT_INPUT_PARAM_STR," # Result.input_fmt)	
	}

	//�رջ���
	closeBuf(param_result.param_buf)


	stop
}

/********************************************************************
*����ԭ��:
			macro FUNCTION_auto_data_req()
*����˵��:
			��
*����˵��:
			���ݺ��������Զ����ɲ���trace���롣
*����ֵ:
			��
********************************************************************/
macro FUNCTION_auto_trace()
{
	var hbuf			//���ݻ���
	var hwnd			//���ھ��
	var ln				//�к�
	var param_result		//���������������
	var sz_text
	var Result
	var ln_trace
	var trace_result
	var index
	var flag
	var str
	var trace_flag
    hwnd = GetCurrentWnd( )     // ȡ�õ�ǰ����
    if(hwnd == 0)
        stop
    hbuf = GetCurrentBuf( )     // ȡ�õ�ǰ�ļ�����

	ln = GetWndSelLnFirst (hwnd)	//ȡ�õ�ǰ���к�

	sz_text=GetBufLine(hbuf,ln)	//ȡ�õ�ǰ������

	//��������
	param_result = FUNCTION_parse_param(sz_text)
	
	//��ӡ
	trace_flag = 0
	Result = FUNCTION_print_trace(param_result.param_buf, param_result.param_count,trace_flag)


	//��ӡ��������
	ln_trace = ln + 1
	index = 0
	while(index < 30)
	{
		 
		trace_result = GetBufLine(hbuf,ln_trace)		
//		msg trace_result
		flag = FindString(trace_result , "RTSPDB_TRACE_IN")
//		msg flag
		if(flag != "X")	//�ҵ����trace
		{
			break;
		}
		index = index +1
		ln_trace = ln_trace +1 	
	}
	if(index == 30)
	{
		msg "cant find RTSPDB_TRACE_IN"
	}
	else
	{
		str = "        RTSPDB_TR_trace(func_name, RTSPDB_TRACE_IN, " # Result.input_fmt
		//msg str
		PutBufLine (hbuf, ln_trace, str)
	}

	ln_trace = ln_trace + 1
	index = 0
	while(index < 100)
	{
		trace_result = GetBufLine(hbuf,ln_trace)		
		flag = FindString(trace_result , "RTSPDB_TRACE_OUT")
		if(flag != "X")	//�ҵ����trace
		{
			break;
		}
		index = index +1
		ln_trace = ln_trace +1 	
	}

	if(index == 30)
	{
		msg "cant find RTSPDB_TRACE_OUT"
	}
	else
	{
		PutBufLine (hbuf, ln_trace, "        RTSPDB_TR_trace(func_name, RTSPDB_TRACE_OUT, " # Result.output_fmt)
	}


	
//	Insert_Line_Before_Next SetBufSelText ( hbuf, "RTSPDB_TR_trace(func_name, RTSPDB_TRACE_IN," # Result.input_fmt)
//	Insert_Line_Before_Next SetBufSelText ( hbuf, "RTSPDB_TR_trace(func_name, RTSPDB_TRACE_OUT," # Result.output_fmt)


	//�رջ���
	closeBuf(param_result.param_buf)

	stop
}

/********************************************************************
*����ԭ��:
			macro FUNCTION_parse_param(string)
*����˵��:
			string:����ĺ������ƺͲ�����
*����˵��:
			���������еĲ���������洢��һ��param_buf����
			param_buf�ĸ�ʽ����
			param_struct.type			��������
			param_struct.flag			��������������־
			param_struct.variable		��������
			param_struct.index		�������������ֵĵ�һ���ַ�����
			.....
			���ѭ������
*����ֵ:
			result: �Ѿ���ӡ��ɵĸ�ʽ�ַ���
********************************************************************/
macro FUNCTION_parse_param(string)
{
	var result
	var param_buf	//�洢��������Ļ���
	var index 		//��ǰ����
	var param_count	//�����ĸ���
	var first_ch_index	//ȡ�ַ���ʱ�ĵ�һ������
	var last_ch_index	//ȡ�ַ���ʱ�����һ������	
 	var len			//�������ַ�������
	var step_flag	//0-���ʾ��������  1-��ʶ���ұ���
	var point_flag	//�Ƿ����"*"�ı�־
	var f_ch		//��һ���ַ�
	var sz_text		//�ַ���
	var ch			//��ʱ�ַ�
	var param_struct	//���������λ


	//�������� 
	param_buf = NewBuf ("param_buf")

	sz_text = string

	len = strlen(sz_text)

	//���Һ���������	
	index=0
	ch=sz_text[index]
	while(ch!="(")
	{
		index=index+1
		ch=sz_text[index]
	}



	//����Ϊ��������
	index = index + 1
	param_count = 0
	while( index <= len )
	{

		first_ch_index = index;
		last_ch_index = index;

		step_flag = 0;/*��ʼ������*/
		point_flag = 0;/*Ĭ�ϲ�Ϊָ��*/

		while(1)
		{
			//ʹfirst_ch_index��Ϊ�ո����*
			f_ch = sz_text[first_ch_index]
			while( f_ch == " " || f_ch == "*")
			{
				if(f_ch == "*")
				{
					point_flag = 1;
				}
				first_ch_index = first_ch_index + 1

				//���µ�ǰ��index
				index = first_ch_index
				f_ch = sz_text[first_ch_index]
			}

			ch = sz_text[index]

			if(ch == " " || ch == "*" || ch == "," || ch == ")")
			{
				if(ch == "*")
				{
					point_flag = 1;
				}
			
				if(step_flag == 0)/*�ҵ�����*/
				{	
					step_flag = 1
					
					last_ch_index = index ;

					param_struct.type = strmid(sz_text, first_ch_index, last_ch_index)
					param_struct.type_index = first_ch_index
					//Msg(param_struct.type)
					first_ch_index = index ;
				}
				else/*�ҵ�������*/
				{
					step_flag = 0
					last_ch_index = index ;
					param_struct.variable = strmid(sz_text, first_ch_index, last_ch_index)
					//Msg(param_struct.variable)
					first_ch_index = index ;
				}
				
				//ʹfirst_ch_index��Ϊ�ո����*
				f_ch = sz_text[first_ch_index]
				while( f_ch == " " || f_ch == "*")
				{
					if(f_ch == "*")
					{
						point_flag = 1;
					}
					first_ch_index = first_ch_index + 1

					//���µ�ǰ��index
					index = first_ch_index
					f_ch = sz_text[first_ch_index]
				}
			}

			ch = sz_text[index]
			if(ch == "," || ch == ")")
			{
				param_struct.flag = point_flag
				//Msg(param_struct)


				//���ɼ���������д��buff
				if(param_struct.type != "")
				{
					AppendBufLine(param_buf, param_struct.type)				
					AppendBufLine(param_buf, param_struct.flag)
					AppendBufLine(param_buf, param_struct.variable)
					AppendBufLine(param_buf, param_struct.type_index)
					param_count = param_count+1

				}
				
				index = index+1
				first_ch_index = index
				break;
			}
			
			index = index +1
		}
		if(ch == ")")
		{
			break
		}

	}

	result.param_buf = param_buf
	result.param_count = param_count

	return result
}

/********************************************************************
*����ԭ��:
			macro FUNCTION_print_trace(param_buf, param_count,flag)
*����˵��:
			param_buf:�������壬��FUNCTION_parse_param���ɡ�
			param_count:����������
			flag:
				-0 ��ʾtrace
				-1 ��ʾdata_req
*����˵��:
			�������еĲ������ո�ʽ��ӡ
*����ֵ:
			Result.input_fmt	��������ĸ�ʽ��������ʽ�ַ����ͱ�����
			Result.input_fmt	��������ĸ�ʽ��������ʽ�ַ����ͱ�����
********************************************************************/
macro FUNCTION_print_trace(param_buf, param_count,flag)
{
	var index
	var ln_count	//param_buf������
	var param_index //��������
	var input_fmt	//��������ĸ�ʽ�ַ���
	var input_name	//��������ı���
	var output_fmt	//���������ʽ�ַ���
	var output_name	//��������ı���
	var type		
	var name
	var point_flag	//ָ���־
	var type_index
	var unit_fmt	//��λ��ʽ%d,%g
	var var_struct_flag	//��ʶ�����Ǳ������߽ṹ��
	var hwnd
	var hbuf
	var ln
	var hwnd_new
	var hbuf_new
	var ln_new
	var wnd_sel
	var tmp_buf
	var struct_type
	var lay_num
	var htmpbuf //��Žṹ���������ʱ����
	var struct_result
	var Result

	input_fmt = " "
	input_name = " "	
	output_fmt = " "
	output_name = " "
	unit_fmt = ""

	ln_count = GetBufLineCount (param_buf)

	param_index = 0
//	msg (param_count)
	while(param_index < param_count)
	{
		var_struct_flag = 0	//Ĭ��Ϊ����
		type = ""
		type = GetBufLine (param_buf, param_index*4)	//��������
		point_flag = GetBufLine (param_buf, param_index*4 + 1)//����������������־
		name = GetBufLine (param_buf, param_index*4 + 2)	//���ұ�����
		index = GetBufLine (param_buf, param_index*4 + 3)	//���͵�һ���ַ�������

		if(type == "double" || type == "float")
		{
			unit_fmt = " %g"
		}
		else if(type == "int" || type == "time_t" || type == "short" || type == "SMEE_BOOL")
		{
			unit_fmt = " %d"
		}
		else	//�ṹ�����ָ��
		{
		    hwnd = GetCurrentWnd( )     // ȡ�õ�ǰ����
		    if(hwnd == 0)
		        stop
		    hbuf = GetCurrentBuf( )     // ȡ�õ�ǰ�ļ�����

			ln = GetWndSelLnFirst (hwnd)	//ȡ�õ�ǰ���к�
		
			//�趨����
			SetBufIns(hbuf, ln, index)

			Jump_To_Base_Type

			hwnd_new= GetCurrentWnd ( )//ȡ�õ�ǰ����
			if ( hwnd_new== 0 )
				stop
			hbuf_new= GetCurrentBuf ( )//ȡ�õ�ǰ�ļ�����
			ln_new = GetWndSelLnFirst (hwnd_new)	//ȡ�õ�ǰ���к�
			wnd_sel = GetWndSel (hwnd_new)
			tmp_buf =GetBufLine (hbuf_new, ln_new)
			struct_type = strmid (tmp_buf, wnd_sel.ichFirst, wnd_sel.ichLim)

			if(struct_type == "enum")
			{
				unit_fmt = " %d"
				Go_Back
			}

			//����ǽṹ�壬ѭ������
			if(struct_type == "struct")			
			{
				lay_num = 0
				htmpbuf = NewBuf("tmp_buf")
				STRUCT_auto_parse(htmpbuf, hwnd, hbuf, ln, lay_num)
				var_struct_flag = 1 //�趨��־
			}
		}


		if(point_flag == 0)//�������
		{
			if(var_struct_flag == 1) //����ǽṹ�� 
			{
				name = name # "."
				struct_result = FUNCTION_print_struct(htmpbuf, name, flag)
				input_fmt = input_fmt # struct_result.fmt 
				if(flag == 0)//trace
				{
					input_name = input_name # struct_result.name 
				}
				else //data_req
				{
					input_name = input_name # struct_result.name	 
				}

				closeBuf(htmpbuf)
			}
			else
			{
				input_fmt = input_fmt # name # "=" # unit_fmt # ","
				if(flag == 0)//trace
				{
					input_name = input_name # name # ","				
				}
				else //data_req
				{
					input_name = input_name # "\&" # name # ","							
				}

//				input_name = input_name # name # ","
 			}
		}
		else	//�������
		{
			if(var_struct_flag == 1) //����ǽṹ�� 
			{
//				name = "(*" # name # ")"
				name = name # "->"				
				struct_result = FUNCTION_print_struct(htmpbuf, name, flag)
				output_fmt = output_fmt # struct_result.fmt 
				//output_name = output_name # struct_result.name

				if(flag == 0)//trace
				{
					output_name = output_name # struct_result.name 
				}
				else //data_req
				{
					output_name = output_name # struct_result.name 
				}
				closeBuf(htmpbuf)
			}
			else
			{
				name = "(*" # name # ")"
				output_fmt = output_fmt # name # "=" # unit_fmt # ","
				//output_name = output_name # name # ","
				if(flag == 0)//trace
				{
					output_name = output_name # name # ","				
				}
				else //data_req
				{
					output_name = output_name # "\&" # name # ","								
				}				
 			}		
		}
		param_index = param_index +1
	}

	//ȥ�����һ��","

	//�ж��Ƿ�Ϊ��
//	if(input_name == " ")
//	{
//		Result.input_fmt = "\">()\");"
//	}
//	else
//	{
//		input_fmt = strmid(input_fmt, 0, strlen(input_fmt)-1)
//		input_name = strmid(input_name, 0, strlen(input_name)-1)
//		Result.input_fmt = "\">(" # input_fmt # ")\"," # input_name # ");"
//	}

//	if(output_name == " ")
//	{
//		Result.output_fmt = "\"<()=%s\", error_str);"
//	}
//	else
//	{
//		output_fmt = strmid(output_fmt, 0, strlen(output_fmt)-1)
//		output_name = strmid(output_name, 0, strlen(output_name)-1)
//		Result.output_fmt = "\"<(" # output_fmt # ")=%s\"," # output_name # ", error_str);"
//	}



	if(flag == 0)//trace
	{
		//�ж��Ƿ�Ϊ��
		if(input_name == " ")
		{
			Result.input_fmt = "\">()\");"
		}
		else
		{
			input_fmt = strmid(input_fmt, 0, strlen(input_fmt)-1)
			input_name = strmid(input_name, 0, strlen(input_name)-1)
			Result.input_fmt = "\">(" # input_fmt # ")\"," # input_name # ");"
		}

		if(output_name == " ")
		{
			Result.output_fmt = "\"<()=%s\", error_str);"
		}
		else
		{
			output_fmt = strmid(output_fmt, 0, strlen(output_fmt)-1)
			output_name = strmid(output_name, 0, strlen(output_name)-1)
			Result.output_fmt = "\"<(" # output_fmt # ")=%s\"," # output_name # ", error_str);"
		}
	}
	else //data_req
	{
		//�ж��Ƿ�Ϊ��
		if(input_name == " ")
		{
			Result.input_fmt = "NULL);"
		}
		else
		{
			input_fmt = strmid(input_fmt, 0, strlen(input_fmt)-1)
			input_name = strmid(input_name, 0, strlen(input_name)-1)
			Result.input_fmt = "\"(" # input_fmt # ")\"," # input_name # ");"
		}

		if(output_name == " ")
		{
			Result.output_fmt = "\"error_code = %x\", &error_code);"
		}
		else
		{
			msg output_name
			output_fmt = strmid(output_fmt, 0, strlen(output_fmt)-1)
			output_name = strmid(output_name, 0, strlen(output_name)-1)
			Result.output_fmt = "\"(" # output_fmt # ", error_code = %x)\"," # output_name # ", &error_code);"
		}
	}
//	msg Result.input_fmt
//	msg Result.output_fmt

	return Result
}


/********************************************************************
*����ԭ��:
			macro FUNCTION_print_trace(param_buf, param_count,flag)
*����˵��:
			htmpbuf:��ʱ���壬�ɽṹ�����������
			var_name:��������
			flag:
				-0 ��ʾtrace
				-1 ��ʾdata_req
*����˵��:
			���ṹ���е����ݰ��ո�ʽ�ַ����ͣ���������ӡ
*����ֵ:
			Result.name	�ṹ��������ַ�����
			Result.fmt	�ṹ��ĸ�ʽ�ַ�����			
********************************************************************/
macro FUNCTION_print_struct(htmpbuf, var_name, flag)
{
	var ln_count //���峤��
	var ln		//��ǰ��
	var print_buf	//��ӡ����
	var string		//��ӡ�ı����ַ���
	var data		//�����������	
	var ln_text		//ָ���е�����
	var cur_lay		//��ǰ����

	var diff		//ָ���в����뵱ǰ����֮��

	var index 		//�ַ���������

	var ch
	var hnewWnd
	var unit		//��ӡ��ʽ����λ
	var input	
	var Result

	Result.fmt = ""
	Result.name = ""
	
	ln_count = GetBufLineCount (htmpbuf)

//	print_buf = NewBuf ("print_buf")

	ln = 0

	cur_lay = 1

	input = var_name
	
	while(ln < ln_count)
	{

		ln_text = GetBufLine(htmpbuf,ln);
		data = STRUCT_parse_buf_line(ln_text)

		//�����struct,������Ӧ��string
		if(data.union == "struct")
		{
			if(data.layer_num <= cur_lay)
			{
				diff = 	cur_lay - data.layer_num + 1	//���������ͬ������Ҫ�������1��

				while(diff != 0 || string == nil)
				{
					index = strlen(string)

					if(index == 0)
					{
						break
					}
					index = index -2
					ch = string[index]
					while(ch != "." && index != 0)//���ҵ�����2��".",����Ϊ��
					{
						index = index -1
						ch = string[index]
					}
					if(index == 0)
					{
						string = nil
					}
					else
					{
						string = strmid(string, 0, index+1)					
					}
					diff = diff -1
				}

				//��¼�µ�ǰ�Ľṹ��
				string = cat (string, data.variable # ".")
			}
			else
			{//����Ǹ���һ��Ľṹ��
				string = cat (string, data.variable # ".")
			}
			//��¼��ǰ�Ĳ���
			cur_lay = data.layer_num
		}
		else
		{
			if(data.layer_num <= cur_lay)
			{
				diff = 	cur_lay - data.layer_num + 1	//���������ͬ������Ҫ�������1��

				while(diff != 0 || string == nil)
				{
					index = strlen(string)

					if(index == 0)
					{
						break
					}

					index = index -2
					ch = string[index]
					while(ch != "." && index != 0)//���ҵ�����2��".",����Ϊ��
					{
						index = index -1
						ch = string[index]
					}

					if(index == 0)
					{
						string = nil
					}
					else
					{
						string = strmid(string, 0, index+1)					
					}

					diff = diff -1
				}
			}
			//��¼��ǰ�Ĳ���
			cur_lay = data.layer_num -1

			//������д�뻺��
			if(data.type == "float" || data.type == "double" )
			{
				unit = "%g"
			}
			else if(data.type == "char")
			{
				unit = "%c"			
			}
			else
			{
				unit = "%d"			
			}
			
			Result.fmt = Result.fmt # input  # string # data.variable  # "= " # unit # ","
//			Result.name = Result.name  # " " # input  # string # data.variable # ","

			if(flag == 0)//trace
			{
				Result.name = Result.name  # " " # input  # string # data.variable # ","
			}
			else //data_req
			{
				Result.name = Result.name  # " &" # input  # string # data.variable # ","
			}
		}

		ln = ln+1
	}

	return Result;

}


