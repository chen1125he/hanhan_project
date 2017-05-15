CKEDITOR.dialog.add('tag', function(editor) {
	var tagButtons = new Array();
	function tagButtonOnClick(obj){
		var selectText = editor.getSelection().getSelectedText();
		editor.insertHtml(selectText + obj.className);
		obj._.dialog.hide();
	}
	var hboxWidth = new Array('1%','50%', '30%', '19%');
	if(typeof(contentBlockKeys) == 'undefined') contentBlockKeys = new Array();
	tagButtons.push({
		id:'cbe',type: 'hbox',widths: hboxWidth,
		children :[  {type: 'html',html: ''},
	                 {type: 'html',html: 'パーツ名'},
	                 {type: 'html',html: 'タグ'},
	                 {type: 'html',html: ''}]
	});
	for(var i = 0 ; i<contentBlockKeys.length ;i++ ){
		tagButtons.push({
			type: 'hbox', widths: hboxWidth,
			children :[  {type: 'html',html: ''},
		                 {type: 'html',html: '<span class="tag-name-250">'+contentBlockKeys[i][1]+"</span>"},
		                 {type: 'html',html: '<span class="tag-name-150">${'+contentBlockKeys[i][0]+"}</span>"},
		                 {type: 'button',label:  '選択する',
						    className: '${'+contentBlockKeys[i][0]+"}",
						    onClick: function(){ tagButtonOnClick(this);}
		                 }
		   ]}
		);
	}
	var _escape = function(value){
		return value;
	};
	return {
		title: 'タグ',
		resizable: CKEDITOR.DIALOG_RESIZE_NONE,
		width: 500,
		height: 400,
		contents: [{
			id: 'cb', title: 'タグ',
			elements: tagButtons
		}],
		buttons:[ CKEDITOR.dialog.cancelButton ],
		onCancel: function(){
			this.hide();
		},
		onLoad: function(){
				//sss = this;
				$(this.getElement().$).find('.cke_dialog_contents_body').css({'display':'block','overflow-y':'auto','margin-top':'0'});
				$(this.getElement().$).find('.tag-name-150').css({'display':'inline-block','overflow':'hidden','max-width':'140px'});
				$(this.getElement().$).find('.tag-name-250').css({'display':'inline-block','overflow':'hidden','max-width':'240px'});
//				$("#"+this._.contents.cb.undefined.domId).parents('.cke_dialog_page_contents').addClass('cbs');
		}
	};
});