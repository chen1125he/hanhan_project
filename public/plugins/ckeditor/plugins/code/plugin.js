CKEDITOR.plugins.add('code', {
//    requires: ['dialog'],
	init: function (editor) {
		editor.addCommand('code','code');
		//editor.addCommand('code');
//		editor.ui.add('code',CKEDITOR.UI_MENUBUTTON  ,{
//			label: 'code',
//			command: 'code',
//			items: [
//		        	[ 'if...else...', 'ifelse' ],
//	        		[ 'if', 'if' ],
//	        		[ 'for', 'for' ],
//	        		[ 'foreach', 'foreach' ]
//		        ]
//		});
		

		thisAutoCodeItems = new Array();
		for(i = autoCodeItems.length -1 ;i >=0  ; i--)
			thisAutoCodeItems.unshift([ autoCodeItems[i][1],autoCodeItems[i][0],'' ]);
		
		var tags = thisAutoCodeItems; //new Array();
		//this.add('value', 'drop_text', 'drop_label');
		editor.ui.addRichCombo('code',{
			label: 'コードセグメント',
			command: 'code',
			className: 'autoWidthRichCombo',
	        panel:
	        {
	        	css:[CKEDITOR.skin.getPath("editor")].concat(editor.config.contentsCss)//,
	        	//multiSelect:!1,attributes:{"aria-label":f.panelTitle}
	        },
			init : function()
			{
			   //this.startGroup( "Tokens" );
			   //this.add('value', 'drop_text', 'drop_label');
			   for (var this_tag in tags){
			      this.add(tags[this_tag][0], tags[this_tag][1], tags[this_tag][2]);
			   }
			},
			
			onClick : function( value )
			{         
			   editor.focus();
			   editor.fire( 'saveSnapshot' );
			   //editor.insertHtml(value);
			   var selectText = editor.getSelection().getSelectedText();
			   var sel = value;
			   selectText = getAutoCode(sel,selectText);
			   editor.insertHtml( '<pre><code class="language-twightml">'+selectText+'</code></pre>' );
			   editor.fire( 'saveSnapshot' );
			},
			onShow: function(value)
			{
				ssss = this;
			}
		});
//		editor.ui.addButton('code', {
//			label: 'code',
//			command: 'code',
//			icon: this.path + 'images/icon.gif',
//		});
//		CKEDITOR.dialog.add('code', this.path + 'dialogs/d.js');
	}
});