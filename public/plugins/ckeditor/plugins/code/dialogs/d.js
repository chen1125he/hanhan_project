CKEDITOR.dialog.add('code', function(editor) {
//	var _escape = function(value){
//	return value;
//	};
	return {
		title: 'コードを挿入する必要性を選択します',
		resizable: CKEDITOR.DIALOG_RESIZE_BOTH,
		minWidth: 360,
		minHeight: 150,
		contents: [{
			id: 'cb',
			name: 'cb',
			label: 'cb',
			title: 'cb',
			elements: [{
				type: 'select',
				id: 'country',
				items: [autoCodeItems]
           }]
		}],
		onOk: function(){
			var selectText = editor.getSelection().getSelectedText();
			var sel = this.getValueOf('cb', 'country');
			selectText = getAutoCode(sel,selectText);
			editor.insertHtml( selectText );
		},
		onCancel: function(){
			this.hide();
		},
		onLoad: function(){
		}
	};
});