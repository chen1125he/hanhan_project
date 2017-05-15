/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

'use strict';
var tableData;
function setDataTiem(obj){
	obj.daterangepicker({
        singleDatePicker: true,
    	format: 'YYYY/MM/DD',
    	timePicker: false,
        calender_style: 'picker_4',
        locale: {
            applyLabel: '確認',
            cancelLabel: 'キャンセル',
            daysOfWeek: ['日', '月', '火', '水', '木', '金', '土'],
            monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
            firstDay: 1
        },
        applyClass: 'applyBtn btn btn-small btn-sm btn-success',
        cancelClass: 'cancelBtn btn btn-small btn-sm btn-default',
    	timePicker12Hour: false            		
    }, function (start, end, label) {
        //console.log(start.toISOString(), end.toISOString(), label);
    	this.element.keydown();
    });
}
function getTablesName(){
	show_loading();
	$.ajax('/admin/table_user_defineds/ajax_get_tables',
		{
			type: 'get',
			dataType: 'json',
			success: function(assets){
				var common_opt = '';
				var nomal_opt  = '';
				var common_calendar_opt = '';
				var nomal_calendar_opt  = '';
				for(var i = 0 ; i < assets.length ; i++ ){
					var this_opt = "<option value   	= '"+assets[i].name+"' \
											tableid 	= '"+assets[i].tableid+"' \
											manage  	= '"+assets[i].manage+"' \
											table-name 	= '"+assets[i].tableName+"' \
											calendar 	= " +assets[i].calendar+" \
											common  	= " +assets[i].common+" \
										>"+assets[i].show+"</option>";
					if(assets[i].calendar){
						if(assets[i].common)
							common_calendar_opt += this_opt;
						else
							nomal_calendar_opt  += this_opt;
					}else{
						if(assets[i].common)
							common_opt += this_opt;
						else
							nomal_opt  += this_opt;
					}
				}
				$("#table_name").html('');
				if((!common_opt)&&(!nomal_opt)&&(!common_calendar_opt)&&(!nomal_calendar_opt))
					$("#table_name").append("<option value=''>テーブルが見つかりませんでした。</option>");
				else $("#table_name").append("<option value='' disabled='' selected='' class='notice-opt'>テーブルを選択してください。</option>");
				if(common_opt) $("#table_name").append("<optgroup class='nomal-opt' label='共通テーブル'>"+common_opt+"</optgroup>");
				if(nomal_opt)  $("#table_name").append("<optgroup class='nomal-opt' label='テーブル'>"+nomal_opt+"</optgroup>");
				if(common_calendar_opt) $("#table_name").append("<optgroup label='共通カレンダーテーブル'>"+common_calendar_opt+"</optgroup>");
				if(nomal_calendar_opt)  $("#table_name").append("<optgroup label='カレンダーテーブル'>"+nomal_calendar_opt+"</optgroup>");
				initTableData(0);
				hide_loading();
				//$(".select2_multiple").select2({maximumSelectionLength: 0,placeholder: "フィールド を選択してください。",allowClear: true});
			},
			error:function (XMLHttpRequest, textStatus, errorThrown){
				hide_loading();
				$("#table_name").html('');
				if(XMLHttpRequest.status == 403)
					window.open(window.location.href);
			}
		} 
	);
}
var fields = [];
var connect_fields = [];
function getFieldsName(tableid,form_connect_table,controlid){
	show_loading();
	var ajaxurl = '/admin/table_user_defineds/ajax_get_fields?' + (form_connect_table ? 'tableid=':'need_connect_field=need&tableid=') + tableid ;
	$.ajax(ajaxurl,
		{
			type: 'get',
			dataType: 'json',
			success: function(getfields){
				if(form_connect_table){
					hide_loading();
					set_table_connect_atr(controlid,getfields.shift());
				}else{
					$("#table_opt").slideDown(100);
					fields = getfields.shift();
					fields = fields.fields;
					fields.push({name:'id',show:'ID',type:'integer'});
					fields.push({name:'created',show:'作成時間',type:'datetime'});
					fields.push({name:'modified',show:'更新時間',type:'datetime'});
					$('.select2-dropdown').hide();
					var fields_is_visible = $('#fields_group').is(':visible');
					if(!fields_is_visible) $('#fields_group').show();
					$('#fields_group').html(fields_html);
					connect_fields = getfields;
					init_fields_select();
					$(".select2_multiple").select2({maximumSelectionLength: 0,placeholder: "フィールド を選択してください。",allowClear: true});
					add_where('#where_control',true);
					add_where('#order_control',true);
					add_where('#table_connect',true);
					initTableData(1);
					hide_loading();
					if(!fields_is_visible) $('#fields_group').hide();
				}
			},
			error: function(){
				$('.select2-dropdown').hide();
				$('#fields_group').html('');
				hide_loading();
				if(XMLHttpRequest.status == 403)
					window.open(window.location.href);
			}
		} 
	);
}
function doGetFields(form_table_select){
	if(form_table_select == true){
		if($('#table_name').val()){
			getFieldsName($('#table_name option:checked').attr('tableid'),false);
		}else{
			$("#table_opt").slideUp(100);
			$('#fields_group').html('');
		}
	}else{
		var controlid = '#'+ $(this).parent().attr('id');
		if($(this).val()){
			getFieldsName($(this).find('option:checked').attr('tableid'),true,controlid);
		}
	}
}
function init_fields_select(){
	var getfields = connect_fields;
	$(".select2_multiple").html('');
	for(var i = 0 ; i < fields.length ; i++ )
		$(".select2_multiple").append("<option value='"+fields[i].name+"'>"+fields[i].show+"</option>");
	for(var ct in getfields){
		for(var ctf in getfields[ct].fields){
			$(".select2_multiple").append(
				"<option value='"+getfields[ct].fields[ctf].name+"'>"+
					"("+getfields[ct].table+') '+getfields[ct].fields[ctf].show+
				"</option>");
		}
	}
	$('#table_connect .live hide').each(function(){
		$(".select2_multiple").append($(this).html());
	});
	$(".select2_multiple").select2({maximumSelectionLength: 0,placeholder: "フィールド を選択してください。",allowClear: true});
}
function set_btn_enable() 	{ $('.modal-content .modal-footer .btn-primary').removeAttr('disabled');}
function set_btn_disable()	{ $('.modal-content .modal-footer .btn-primary').attr('disabled','disabled');}
function only_num(thisInp,allowMore){
	var regexp = allowMore?/[^\d\.+-]/g:/(\D)/g;
	if(regexp.test($(thisInp).val())){
		var noNum = $(thisInp).val().replace(regexp,'');
		$(thisInp).val(noNum);
	}
}
function parseDom(arg) 	{ var objE = document.createElement("div"); objE.innerHTML = arg; return objE.childNodes; }; 
function check_val(){
	var listChecked = $('[name="data_type"]:checked').val() == 'list';
	var infoChecked = $('[name="data_type"]:checked').val() == 'info';
	var calendarChecked = $('[name="data_type"]:checked').val() == 'calendar';
	var listEnable = $('#table_name').val() && listChecked;
	var infoEnable = $('#table_name').val() && infoChecked && $('#key_name').val() ;
	var calendarEnable = $('#table_name').val() && calendarChecked && $('#calendar_type').val() ;
	if( listEnable || infoEnable || calendarEnable)
		set_btn_enable();
	else
		set_btn_disable();
}
var connect_table_where_id = 0;
function add_where(controlid,new_where){
	var where_line_html = '<div class="die clearfix"><select class="field-sel form-control"></select><atr></atr><c></c></div>';
	if(controlid == '#table_connect'){
		var this_connect_table_where_id = 'table-connect-'+(connect_table_where_id++);
		where_line_html = '<div id="'+this_connect_table_where_id+'" class="die clearfix"><select class="field-sel form-control"></select>\
		<i class="table-connect-fa fa"></i>\
		<select class="table-sel form-control">'+$("#table_name").html()+'</select>\
		<atr><select class="connect-field-select form-control" disabled="disabled"></select><hide></hide></atr><c></c></div>';
	}
	where_line_html = parseDom(where_line_html);
	for(var i = 0 ; i < fields.length ; i++ )
		if(fields[i].type!='image'&&fields[i].type!='file')
			$(where_line_html).find('.field-sel').append("<option ftype='"+fields[i].type+"' value='"+fields[i].name+"'>"+fields[i].show+"</option>");
	if(controlid != '#table_connect'){
		for(var ct in connect_fields){
			var ctfs = connect_fields[ct].fields;
			ctfs.push({name:'id',show:'ID',type:'integer'});
			ctfs.push({name:'created',show:'作成時間',type:'datetime'});
			ctfs.push({name:'modified',show:'更新時間',type:'datetime'});
			for(var ctf in ctfs)
				$(where_line_html).find('.field-sel').append(
					"<option ftype='"+ctfs[ctf].type+"' value='"+ctfs[ctf].where+"' table='"+connect_fields[ct].manage+"'>"+
						"("+connect_fields[ct].table+") "+ctfs[ctf].show+
					"</option>");
		}
		$('#table_connect .live hide').each(function(){
			$(where_line_html).find('.field-sel').append($(this).html());
		});
	}
	$(where_line_html).find('c').append('<a class="btn btn-round btn-warning"><i class="fa fa-minus"></i></a>');
	$(where_line_html).find('c').append('<a class="btn btn-round btn-success"><i class="fa fa-plus" ></i></a>');
	$(where_line_html).find('.btn-success').click(add_where_line);
	$(where_line_html).find('.btn-warning').click(del_where_line);
	var should_add_where_line = true;
	if(controlid == '#table_connect'){
		$(where_line_html).find('.table-sel option').each(function(){
			if($(this).attr('disabled') != 'disabled'){
				//删除自身table选项
				if($(this).attr('tableid') == $('#table_name option:checked').attr('tableid'))
					$(this).remove();
				//删除已经选择链接了的table选项
				var all_sel_table = $('.table-sel option:checked');
				for (var i = 0; i < all_sel_table.length; i++) {
					if($(this)[0].outerHTML == all_sel_table[i].outerHTML)
						$(this).remove();
				};
				//删除table定义内已经链接的table选项
				for (var i = 0; i < connect_fields.length; i++) {
					if(connect_fields[i].manage == $(this).attr('manage'))
						$(this).remove();
				};
			}
		});
		$(where_line_html).find('.table-sel optgroup').each(function(){
			if($(this).html() == '')
				$(this).remove();
		});
		var this_table_sel = $(where_line_html).find('.table-sel');
		if(this_table_sel.find('option').length <= 1)
			should_add_where_line = false;
		else
			this_table_sel.change(doGetFields);
	}
	else
		$(where_line_html).find('.field-sel').change(set_where_atr);
	if(new_where) $(controlid).html('');
	if(should_add_where_line)
		$(controlid).append(where_line_html);
	$(controlid).find('.field-sel:last').change();
	$(controlid).find('.die').hide().fadeIn();
}
function set_where_atr(){
	var parDiv = $(this).closest('div');
	var controlid = '#'+ parDiv.parent().attr('id');
	var field_type = parDiv.find('.field-sel option:checked').attr('ftype');
	var atr_sel_opt = [];
	switch(field_type){
		case 'integer'		: atr_sel_opt = ['>','>=','=','!=','<','<=','is null','is not null'];break;
		case 'date'			: atr_sel_opt = ['>','>=','=','!=','<','<=','is null','is not null'];break;
		case 'datetime'		: atr_sel_opt = ['>','>=','=','!=','<','<=','is null','is not null'];break;
		case 'string'		: atr_sel_opt = ['=','!=','like','not like','is null','is not null'];break;
		case 'text'			: atr_sel_opt = ['like','not like','is null','is not null'];break;
		case 'text_ckeditor': atr_sel_opt = ['like','not like','is null','is not null'];break;
		case 'image'		: break;
		case 'file'			: break;
	}
	var atr_html = '<select class="atr-sel form-control"';
	if(controlid == '#where_control'){
		atr_html += ' onchange="check_is_select_is_null(this)">';
		for(var i = 0 ; i < atr_sel_opt.length ; i++ )
			atr_html +="<option value='"+atr_sel_opt[i]+"'>"+atr_sel_opt[i]+"</option>";
		atr_html +='</select><input class="form-control" onkeydown="click_this_add(this)" ';
		if(field_type == 'integer') atr_html +='onkeyup="only_num(this,true)" onblur="only_num(this,true)"';
		atr_html +=' />';
	}
	else if(controlid == '#order_control'){
		atr_html +=" onchange='click_this_add(this)'>" +
				"<option disabled='' selected='' class='notice-opt'></option>"+
				"<option value='desc'>降順</option>"+
				"<option value='asc'>昇順</option>";
		atr_html +='</select>';
	}
	parDiv.find('atr').html("");
	parDiv.find('atr').append(atr_html);
	if(field_type == 'datetime')
		setDataTiem(parDiv.find('atr input'));
}
function set_table_connect_atr(controlid,tablefields){
	var table_inf = tablefields;
	tablefields = tablefields.fields;
	tablefields.push({name:'id',show:'ID',type:'integer'});
	tablefields.push({name:'created',show:'作成時間',type:'datetime'});
	tablefields.push({name:'modified',show:'更新時間',type:'datetime'});
	var atr_html = '<select class="connect-field-select form-control" table-manage="'+table_inf.manage+'" table-name="'+table_inf.tablen+'"';
		atr_html +=" onchange='click_this_add(this)'>" ;
		atr_html +="<option disabled='' selected='' class='notice-opt'></option>";
	var hidden_html = '<hide>';
	for (var i = 0; i < tablefields.length; i++) {
		var optval = table_inf.manage+'.'+tablefields[i].name;
		var optval_join = '['+table_inf.manage+'].['+tablefields[i].name+']';
		var long_name = '('+table_inf.table+') '+tablefields[i].show;
		var short_name = tablefields[i].show;
		atr_html +="<option value='"+optval_join+"'>"+short_name+"</option>";
		hidden_html +="<option value='"+optval+"' show='"+short_name+"' ftype='"+tablefields[i].type+"'>"+long_name +"</option>";
	}
	atr_html += '</select>';
	hidden_html += '</hide>'
	var parDiv = $(controlid);
	parDiv.find('atr').html("");
	parDiv.find('atr').append(atr_html + hidden_html);

	if($(controlid+'.live').length > 0){
		$('#table_connect .die').remove();
		add_where('#table_connect');
		init_fields_select();
	}
}
function add_where_line(){
	var parDiv = $(this).closest('div');
	var controlid = '#'+ parDiv.parent().attr('id');
	parDiv.addClass('live');
	parDiv.removeClass('die');
	add_where(controlid);
	if(controlid == '#table_connect'){
		init_fields_select();
		$('#where_control .die').remove();
		$('#order_control .die').remove();
		add_where('#where_control');
		add_where('#order_control');
	}
}
function del_where_line(){
	var parDiv = $(this).closest('div');
	var controlid = '#'+ parDiv.parent().attr('id');
	parDiv.addClass('die-die');
	parDiv.fadeOut(300,function(){
		$(this).remove();
		if(controlid == '#table_connect'){
			$('#table_connect .die').remove();
			add_where('#table_connect');
			init_fields_select();
			$('#where_control .die').remove();
			$('#order_control .die').remove();
			add_where('#where_control');
			add_where('#order_control');
		}
	});
}
function click_this_add(obj){
	var parDiv = $(obj).closest('div');
	if(parDiv.attr('class').indexOf('die') >= 0)
		parDiv.find('.btn-success').click();
}
function check_is_select_is_null(obj){
	if(/is (not )?null/.test($(obj).val())){
		$(obj).next().val('');
		$(obj).next().keydown();
		$(obj).next().attr('disabled','disabled');
	}else{
		$(obj).next().removeAttr('disabled');
	}
}
function show_loading()	{
	$('#table_opt').addClass('on-loading');
	$('.line-loading').addClass('do-loading');
}
function hide_loading()	{
	$('#table_opt').removeClass('on-loading');
	$('.line-loading').removeClass('do-loading');
}
var selectTableByTableData = false;
function initTableData(stip){
	//回显
//	if(tableData && stip == 0){
//		$('#table_name').find('[value="'+tableData[0]+'"]').attr("selected", true);
//		$('#table_name').change();
//		selectTableByTableData = true;
//	}
//	if(tableData && stip == 1  && selectTableByTableData){
//		if(tableData[1]['limit']) $('#limit').val(tableData[1]['limit']);
//		for (var key in tableData[1]['conditions'])
//	    {
//	        var keyArr = key.split(' ');
//	        $('#where_control .die .field-sel').find('[value="'+keyArr[0]+'"]').attr("selected", true);
//			$('#where_control .die .field-sel').change();
//			$('#where_control .die .atr-sel').find('[value="'+keyArr[1]+'"]').attr("selected", true);
//			$('#where_control .die input').val(tableData[1]['conditions'][key]);
//			$('#where_control .die .fa-plus').click();
//	    }
//		for (var key in tableData[1]['order'])
//	    {
//	        $('#order_control .die .field-sel').find('[value="'+key+'"]').attr("selected", true);
//			$('#order_control .die .field-sel').change();
//			$('#order_control .die .atr-sel').find('[value="'+tableData[1]['order'][key]+'"]').attr("selected", true);
//			$('#order_control .die .fa-plus').click();
//	    }
//		selectTableByTableData = false;
//	}
}
function list_or_info(){
	if($('[name="data_type"]:checked').val() == 'list'){
		$('.calendar_control').hide();
		$('.info_control').hide();
		$('.list_control').show();
		$('#fields_group').show();
		$('#table_connect_panel').show();
		$('#table_name').removeClass('hide-nomal-opt');
	}
	if($('[name="data_type"]:checked').val() == 'info'){
		$('.calendar_control').hide();
		$('.list_control').hide();
		$('.info_control').show();
		$('#fields_group').show();
		$('#table_connect_panel').hide();
		$('#table_name').removeClass('hide-nomal-opt');
	}
	if($('[name="data_type"]:checked').val() == 'calendar'){
		$('#fields_group').hide();
		$('.info_control').hide();
		$('.list_control').hide();
		$('#table_connect_panel').hide();
		$('#table_name').addClass('hide-nomal-opt');
		$('#table_name option:first').attr('selected','selected');
		$('.calendar_control').show();
	}
	check_val();
}
function confirm_ready(){
	$('.modal-body input.flat').iCheck({checkboxClass: 'icheckbox_flat-green',radioClass: 'iradio_flat-green'});
	$(".select2_multiple").select2({maximumSelectionLength: 0,placeholder: "フィールド を選択してください。",allowClear: true});
	$('.select2').width('100%');$('.select2-search__field').width('100%');$('.select2-search--inline').width('100%');
	$('.tags').tagsInput({width: 'auto'});
	$('.modal-content .form-group').mouseleave(check_val);
	getTablesName();
	$('.modal-body .radio label ins').click(list_or_info);
	$('.modal-body .radio label').click(list_or_info);
	list_or_info();
	$("#table_opt").hide();
	$('.tips_collapse-link').click(function () {
	    var x_panel = $(this).closest('div.x_panel');
	    var button = $(this).find('i');
	    var content = x_panel.find('div.x_content');
	    content.slideToggle(200);
	    (x_panel.hasClass('fixed_height_390') ? x_panel.toggleClass('').toggleClass('fixed_height_390') : '');
	    (x_panel.hasClass('fixed_height_320') ? x_panel.toggleClass('').toggleClass('fixed_height_320') : '');
	    button.toggleClass('fa-chevron-up').toggleClass('fa-chevron-down');
	    setTimeout(function () {
	        x_panel.resize();
	    }, 50);
	});
}
//数组去重
function unique(arr) {
    var result = [], hash = {};
    for (var i = 0, elem; (elem = arr[i]) != null; i++) {
        if (!hash[elem]) {
            result.push(elem);
            hash[elem] = true;
        }
    }
    return result;
}
function get_auto_code_json_of_join(){
	var join_c = '{';
	var select_table_manage = $('#table_name option:selected').attr('manage');
	$('#table_connect .live').each(function(){
		var thisCF = $(this).find('.connect-field-select');
		if(thisCF.val()){
			var thisFS = $(this).find('.field-sel').val();
			var table_name = thisCF.attr('table-name');
			var left_field_name = "["+select_table_manage+'].['+thisFS+']';
			join_c += thisCF.attr('table-manage') + ':{' +
			"table:'"+table_name+"',"+
			"conditions:'"+left_field_name+' = '+thisCF.val()+"',"+
			"type:'LEFT'},";
			//contain.push("'"+select_table_manage+"'");
		}
	});
	join_c += '}';
	return join_c;
}
function get_auto_code_json_of_select(){
	var select_c = '[';
	for(var selVal in $('#select_fields').val()){
		var thisSelVal = $('#select_fields').val()[selVal];
		if( thisSelVal.indexOf('.') > 0 ){
	    	var fields_in_connect = false;
			for(var ct in connect_fields){
				var ctfs = connect_fields[ct].fields;
				var contain_t = connect_fields[ct].manage;
				for(var ctf in ctfs){
					if(ctfs[ctf].name == thisSelVal)
	        			{ sel_fields.push(ctfs[ctf]); fields_in_connect = true; break; }
				}
	        	if(fields_in_connect){
				contain.push("'"+contain_t+"'"); break;
				}
	        }
	        if(!fields_in_connect){
	        	var all_connect_fields = $('hide option');
	        	for(var acf in all_connect_fields){
	        		var this_opt = $(all_connect_fields[acf]);
	        		if(this_opt.attr('value') == thisSelVal){
	        			sel_fields.push({
	        				name:this_opt.attr('value'),
	        				show:this_opt.attr('show'),
	        				type:this_opt.attr('type')
	        			}); 
	        			select_c += "'"+this_opt.attr('value')+"',";
	        			break;
	        		}
	        	}
	        }
	    }else{
			var fields_in_default = false;
			for(var i = 0 ;i < fields.length ; i++ )
				if(fields[i].name == thisSelVal)
	    			{ sel_fields.push(fields[i]); fields_in_default = true; break; }
	    }
	}
	select_c += ']';
	return select_c;
}
function get_auto_code_json_of_where(){
	var where_c = '{';
	$('#where_control .live').each(function(){
		var atr_sel_val = $(this).find('atr select').val();
		var conL = $(this).find('.field-sel').val() +" "+ atr_sel_val;
		var conR = $(this).find('atr input').val();
		var add_succ = false;
		if(conR.length > 0){
			where_c += "'"+ conL +"' : '"+ conR +"',"; add_succ = true;
		}else if(/is (not )?null/.test(atr_sel_val)){
			where_c += "'"+ conL.replace(' null','') +"' : null,"; add_succ = true;
		}
		if(add_succ){
			var seltable = $(this).find('.field-sel').find(':selected').attr('table');
			if(seltable) contain.push("'"+seltable+"'");
		}
	});
	where_c += '}';
	return where_c;
}
function get_auto_code_json_of_order(){
	var order_c = '{';
	$('#order_control .live').each(function(){
		var conL = $(this).find('.field-sel').val();
		var conR = $(this).find('atr select').val();
		order_c += "'"+ conL +"' : '"+ conR +"',";

		var seltable = $(this).find('.field-sel').find(':selected').attr('table');
		if(seltable) contain.push("'"+seltable+"'");
	});
	order_c += '}';
	return order_c;
}
var sel_fields = [];
var contain = [];
// 生成用于code做成的json
function get_auto_code_json(){
	sel_fields = [];
	contain = [];
	var join_c = get_auto_code_json_of_join();
	var select_c = get_auto_code_json_of_select();
	var where_c = get_auto_code_json_of_where();
	var order_c = get_auto_code_json_of_order();
	if(sel_fields.length == 0)
		sel_fields = fields;
	var codeJson = {
		 'dataType'		: $('[name=data_type]:checked').val(),
		 'tableName'	: $('#table_name').val(),
		 'common'		: $('#table_name option:checked').attr('common'),
		 'selectFields'	: sel_fields,
		 'conditions'	: where_c,
		 'fieldsOrder'	: order_c,
		 'join'			: join_c,
		 'select'		: select_c,
		 'limit'		: $('#limit').val(),
		 'keyName'		: $('#key_name').val(),
		 'calendar_type': $('#calendar_type').val(),
		 'contain'		: unique(contain).join(',')
		};
	return codeJson;
}
var css="<style type='text/css'>\
		.bootstrap-dialog{z-index:10240}\
		.select2-container{z-index:10241}\
		.auto-code .modal-content{margin: 0 150px 0 -150px;}\
		.confirm_control c a{padding:4px 5px 0px 5px!important}\
		.confirm_control atr{float:left;height: 34px;line-height:34px;}\
		.confirm_control c{float:right;height: 34px;line-height:34px;}\
		.confirm_control .live,.confirm_control .die{overflow: hidden;height: 34px;width: 406px;}\
		.confirm_control .die .btn-warning{display:none}\
		.confirm_control .live .btn-success{display:none}\
		@keyframes show_warning{\
				from {background: #26B99A;border-color: #4cae4c;}\
				to {background: #f0ad4e;border-color: #eea236;transform: rotate(360deg);}}\
		@keyframes show_success{from {transform:scale(0,0);}to {transform:scale(1,1);}}\
		@keyframes die_die{to {transform: translate(50px,0px);margin-top:-40px;}}\
		.confirm_control .live .btn-warning{animation: show_warning 1s;}\
		.confirm_control .die .btn-success{animation: show_success 0.5s;}\
		.confirm_control .live.die-die{animation: die_die 0.5s;}\
		.confirm_control .field-sel{width: 120px;float:left}\
		.confirm_control .table-sel,.table-connect-title.connect-table-title{width: 108px;float:left}\
		.confirm_control atr select{width: 100px;float:left}\
		.confirm_control atr input{width: 140px;float:left}\
		.confirm_control atr .connect-field-select,.table-connect-title.connect-field-title{width: 110px;}\
		#table_name optgroup,.table-sel optgroup{color:#999}\
		#table_name option,.table-sel option{color:#111}\
		#table_opt.on-loading{pointer-events: none;opacity:0.5;}\
		.notice-opt{display:none;}\
		.daterangepicker {z-index: 2000;}\
		.tips_html {margin-bottom: 0;}\
		.hide-nomal-opt .nomal-opt {display:none;}\
		.float-tips {position: absolute;top: 0px;border-radius: 6px;box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);}\
		#condition-tips {left: 620px;width: 333px;}\
		.table-connect-title {float:left;text-align: center}\
		.table-connect-title.need-connect-field-title {width: 120px;margin-right: 22px;}\
		i.table-connect-fa{float: left;line-height: 34px;padding-left: 3px;margin-right: 2px;}\
		@keyframes link-table{to {transform: rotate(0deg);}to {transform: rotate(135deg);}}\
		.confirm_control .live .table-connect-fa:before{content: '\\f0c1';}\
		.confirm_control .live .table-connect-fa{animation: link-table 0.5s forwards;}\
		.confirm_control .die  .table-connect-fa:before{content: '\\f127';}\
		hide{display:none};\
		</style>";
var script="<script>confirm_ready()</script>";
var item_start = '<div class="item form-group"><label class="control-label col-md-3 col-sm-3 col-xs-12">';
var inp_start  = '<div class="col-md-9 col-sm-9 col-xs-12">';
var require_span = '<span class="label label-required">必須</span>';
var loading_table_name_op = '<option value="">読み込み中...</option>';
var fields_html = '<label class="control-label col-md-3 col-sm-3 col-xs-12">' + 'フィールド </label>'+
	inp_start + '<select id="select_fields" class="select2_multiple form-control" multiple="multiple"></select></div>';
var tips_html = '<div class="x_panel float-tips" id="condition-tips"><div class="x_title"><h2>条件説明</h2>'+
				'<ul class="nav navbar-right panel_toolbox"><li><a class="collapse-link tips_collapse-link"><i class="fa fa-chevron-up"></i></a></li></ul>'+
				'<div class="clearfix"></div></div><div class="x_content">'+
				"<table class='tips_html table table-bordered responsive-utilities jambo_table bulk_action'>"+
				"<tr><th>パラメータ名</th><th>パラメータコード</th><tr>" +
				"<tr><td>当前日時</td><td>CURRENT_TIME</td><tr>" +
				"</table></div></div>";
var connect_title_html = '<div class="clearfix"><div class="table-connect-title need-connect-field-title">結合フィールド</div>\
												<div class="table-connect-title connect-table-title">結合対象表</div>\
												<div class="table-connect-title connect-field-title">結合フィールド</div></div>';
var msg_html = css + '<div class="form-horizontal form-label-left">'+
	item_start + 'データタイプ'+require_span+'</label>'+
		inp_start + '<div class="radio"><label><input type="radio" checked="checked" name="data_type" value="list" class="flat"/>一覧</label>'+	
	 	'<label><input type="radio" name="data_type" value="info" class="flat"/>詳細</label>'+
	 	'<label><input type="radio" name="data_type" value="calendar" class="flat"/>カレンダー</label></div></div></div>'+
	item_start + 'テーブル'+require_span+'</label>'+
		inp_start + '<select id="table_name" class="form-control" onchange="doGetFields(true);">'+loading_table_name_op+'</select></div></div>'+
	'<div id="table_opt">'+
	'<div id="table_connect_panel">'+
	item_start + '表結合</label>'+
		inp_start + connect_title_html + '<div id="table_connect" class="confirm_control"></div></div></div></div>'+
	'<div id="fields_group" class="item form-group"></div>'+
	'<div class="list_control">'+
	item_start + '表示上限件数</label>'+
		inp_start + '<input type="text" id="limit" class="form-control" onkeyup="only_num(this)" onblur="only_num(this)"/></div></div>'+
	item_start + '条件</label>'+
		inp_start + '<div id="where_control" class="confirm_control"></div></div></div>'+
	item_start + '順番</label>'+
		inp_start + '<div id="order_control" class="confirm_control"></div></div></div>'+
	'</div><div class="info_control">'+
	item_start + 'キー名'+require_span+'</label>'+
		inp_start + '<input type="text" id="key_name" class="form-control"/></div></div>'+
	'</div><div class="calendar_control">'+
		item_start + 'サイズ'+require_span+'</label>'+
		inp_start + '<select id="calendar_type" class="form-control"><option style="display:none"></option><option value="big">大カレンダー</option><option value="small">小カレンダー</option></select></div></div>'+
	'</div></div>'+tips_html+
	'</div><div class="line-loading"><div></div></div>'+script;
( function() {
	CKEDITOR.dialog.add( 'codeSnippet', function( editor ) {
		var snippetLangs = editor._.codesnippet.langs,
			lang = editor.lang.codesnippet,
			clientHeight = document.documentElement.clientHeight,
			langSelectItems = [],
			snippetLangId;

		langSelectItems.push( [ editor.lang.common.notSet, '' ] );

		for ( snippetLangId in snippetLangs )
			langSelectItems.push( [ snippetLangs[ snippetLangId ], snippetLangId ] );

		// Size adjustments.
		var size = CKEDITOR.document.getWindow().getViewPaneSize(),
			// Make it maximum 800px wide, but still fully visible in the viewport.
			width = Math.min( size.width - 70, 800 ),
			// Make it use 2/3 of the viewport height.
			height = size.height / 1.5;

		// Low resolution settings.
		if ( clientHeight < 650 ) {
			height = clientHeight - 220;
		}

		var thisAutoCodeItems = autoCodeItems;
		if($('#content_key').val()=='error400'||$('#content_key').val()=='error500')
			thisAutoCodeItems = autoCodeItems_HasError;
		thisAutoCodeItems.unshift([ 'コードセグメント','no' ]);
		var dialogDefinition = {
			title: lang.title,
			minHeight: 200,
			resizable: CKEDITOR.DIALOG_RESIZE_NONE,
			contents: [
				{
					id: 'info',
					elements: [
						{
							type:'hbox',
							style: 'width:auto;float:left;',
							children:[{
								id: 'lang',
								type: 'select',
								label: lang.language,
								items: langSelectItems,
								style: 'min-width:140px;',
								setup: function( widget ) {
									if ( widget.ready && widget.data.lang )
										this.setValue( widget.data.lang );
									if ( CKEDITOR.env.gecko && ( !widget.data.lang || !widget.ready ) )
										this.getInputElement().$.selectedIndex = -1;
								},
								commit: function( widget ) {
									widget.setData( 'lang', this.getValue() );
								}
							},{
								type: 'select',
								id: 'autocode',
								label: 'コードセグメント',
								items: thisAutoCodeItems,
						        default: 'no',
						        onChange: function() {
						        	var thisValue = '';
						        	if(typeof(CodeMirror) != "function")
						        		thisValue = this._.dialog.getValueOf("info", "code")
						        	else 
						        		thisValue = twigcodemirroreditor.getValue();
						        	var sel = this.getValue();
						        	var selectText = '';
									selectText = getAutoCode(sel,selectText,true);
									if(sel != 'no'){
										this._.dialog.setValueOf("info", "code", selectText );
										var codeArea = $(this._.dialog.getElement().$).find(".cke_dialog_contents_body").find('textarea');
							        	if(typeof(CodeMirror) != "function")
											codeArea.val(thisValue + selectText);
						        		else 
						        			twigcodemirroreditor.setValue(thisValue + selectText);
						        		this._.dialog.setValueOf("info", "lang","twightml");
										this.setValue('no');
									}
						        }
				           },{
								type: 'button',
								id: 'assistants',
								label: 'コード作成',
								style: 'margin-top: 20px;',
								'class':'assistants-btn',
						        onClick: function() {
						        	var thisAssistants = this;
						        	//获取回显数据

						        	try{
							        	tableData = thisAssistants._.dialog.getValueOf("info", "code");
							        	tableData = tableData.match(/(getComTableData|getTableData)\((.*)\)/);
							        	if (tableData) tableData = eval('['+tableData[2]+']');
									}catch(e){
										tableData = [];
									}
						        	function set_code_assistants(codeJson){
							        	var thisValue = '';
							        	if(typeof(CodeMirror) != "function")
							        		thisValue = thisAssistants._.dialog.getValueOf("info", "code")
							        	else 
							        		thisValue = twigcodemirroreditor.getValue();
							        	var selectText = getAutoCode('define_table','',true,codeJson);
										var codeArea = $(thisAssistants._.dialog.getElement().$).find(".cke_dialog_contents_body").find('textarea');
							        	if(typeof(CodeMirror) != "function")
											codeArea.val(thisValue + selectText);
						        		else 
						        			twigcodemirroreditor.setValue(thisValue + selectText);
							        	thisAssistants._.dialog.setValueOf("info", "lang","twightml");
						        	}
						        	BootstrapDialog.show({
							   	        title: 'コード作成',
							   	        message: msg_html, // <-- Default value is false
							   	        draggable: true, // <-- Default value is false
							   	        cssClass:'auto-code', // code做成 dialog 加个class : 设置dialog向右偏移 
							            buttons: [{
							                label: 'キャンセル',
							                action: function(dialogRef) { 
							                	dialogRef.close(); 
							                }
							            },{
							                label: '作成',
							                cssClass:'btn-primary',
							                action: function(dialogRef) {
							   	            	set_code_assistants(get_auto_code_json());
							   	            	dialogRef.close();
							                }
							            }]
						   	     	});
						        }
				           }]
						},{
							id: 'code',
							type: 'textarea',
							label: lang.codeContents,
							setup: function( widget ) {
								this.setValue( widget.data.code );
								if(!twigcodemirrorinited){
									twigcodemirrorinited = true;
									codeSnippetTextareaid = $('#'+this.domId+' textarea').attr('id');
			                        initCodeMirror();
								}else{
									twigcodemirroreditor.setValue($('#'+this.domId+' textarea').val());
								}
							},
							commit: function( widget ) {
								//twigcodeAutoFormatAll();
								widget.setData( 'code', twigcodemirroreditor.getValue() );
							},
							required: true,
							validate: CKEDITOR.dialog.validate.notEmpty( lang.emptySnippetError ),
							inputStyle: 'cursor:auto;' +
								'width:' + width + 'px;' +
								'height:' + height + 'px;' +
								'tab-size:4;' +
								'text-align:left;',
							'class': 'cke_source'
						}
					]
				}
			],
			onShow: function(){
				$('body').addClass('cke-dialog-open');
			},
			onCancel: function(){
				$('body').removeClass('cke-dialog-open');
			},
			onOk: function(){
				$('body').removeClass('cke-dialog-open');
			}

		};
		return dialogDefinition;
	} );
}() );
var twigcodemirrorinited = false;
var twigcodemirroreditor ;
var codeSnippetTextareaid ;
function loadjscssfile(filename,filetype){
    if(filetype == "js"){
        var fileref = document.createElement('script');
        fileref.setAttribute("type","text/javascript");
        fileref.setAttribute("src",filename);
    }else if(filetype == "css"){
    
        var fileref = document.createElement('link');
        fileref.setAttribute("rel","stylesheet");
        fileref.setAttribute("type","text/css");
        fileref.setAttribute("href",filename);
    }
   if(typeof fileref != "undefined"){
        document.getElementsByTagName("head")[0].appendChild(fileref);
    }
}

function loadScriptOneByOne(i,textareaid){
	var scriptFiles = [
		"/js/admin_18779eb481184fcbb8fcb2e07104bb43/ckeditor/plugins/codemirror/js/codemirror.min.js",
		"/js/admin_18779eb481184fcbb8fcb2e07104bb43/ckeditor/plugins/codemirror/js/codemirror.addons.min.js",
		"/js/admin_18779eb481184fcbb8fcb2e07104bb43/ckeditor/plugins/codemirror/js/codemirror.mode.twig.min.js",
		"/js/admin_18779eb481184fcbb8fcb2e07104bb43/ckeditor/plugins/codemirror/js/codemirror.addons.search.min.js"
		];
	CKEDITOR.scriptLoader.load(scriptFiles[i++], function() {
		if(i<scriptFiles.length)
			loadScriptOneByOne(i);
		else{
			initCodeMirror();
		}
	});
}

function initCodeMirror(){
	var textareaid = codeSnippetTextareaid;					
	if(typeof(CodeMirror) != "function"){
		loadjscssfile("/js/admin_18779eb481184fcbb8fcb2e07104bb43/ckeditor/plugins/codemirror/css/codemirror.min.css","css");
		loadScriptOneByOne(0,textareaid);
	}else{
		twigcodemirroreditor = CodeMirror.fromTextArea(document.getElementById(textareaid), {
														mode:{name: "twig", htmlMode: true},
														lineNumbers: true,
      													lineWrapping: true,
    													smartIndent: true,
    													autoCloseTags: true,
													    matchTags: {bothTags: true},
													    extraKeys: {
													    	"Ctrl-J": "toMatchingTag",
													    	"Ctrl-I": function (codeMirror_Editor) {
																	twigcodeAutoFormatSelection();
													    	}
													    },
									                    foldGutter: true,
									                    gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
													});
		$('.cke_dialog_body .CodeMirror').css('border','1px solid #ddd');
		$('.cke_dialog_body .CodeMirror').css('border-radius','4px');
		$('.cke_dialog_body .CodeMirror-sizer').css('width',($('#'+textareaid).outerWidth()-40)+'px');
		$('.cke_dialog_body .CodeMirror-gutters').css('height',$('#'+textareaid).outerHeight()+'px');
		$('.cke_dialog_body .CodeMirror').css('height',$('#'+textareaid).outerHeight()+'px');
		twigcodemirroreditor.on('change',function(){
			$('#'+textareaid).val(twigcodemirroreditor.getValue());
		});
	}
}

function twigcodeAutoFormatSelection() {
	var range = { 
			from: twigcodemirroreditor.getCursor(true), 
			to: twigcodemirroreditor.getCursor(false) 
		};
	twigcodemirroreditor.autoFormatRange(range.from, range.to);
}

function twigcodeAutoFormatAll() {
	twigcodemirroreditor.autoFormatAll({
                            line: 0,
                            ch: 0
                        }, {
                            line: twigcodemirroreditor.lineCount(),
                            ch: 0
                        });
}