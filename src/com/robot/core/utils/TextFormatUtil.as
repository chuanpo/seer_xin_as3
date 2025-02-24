package com.robot.core.utils
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TextFormatUtil
   {
      private static var _tfm:TextFormat = new TextFormat("宋体",12,16777215,null,null,null,null,null,null,null,null,null,3);
      
      public function TextFormatUtil()
      {
         super();
      }
      
      public static function appDefaultFormatText(tf:TextField, str:String, color:uint) : void
      {
         _tfm.color = color;
         _tfm.bold = false;
         _tfm.size = 12;
         _tfm.italic = false;
         _tfm.underline = false;
         appendOne(tf,str);
      }
      
      public static function appContentFormatText(tf:TextField, str:String, mfm:Object) : void
      {
         _tfm.color = mfm.color;
         _tfm.bold = mfm.bold;
         _tfm.size = mfm.size;
         _tfm.italic = mfm.italic;
         _tfm.underline = mfm.underline;
         appendOne(tf,str);
      }
      
      public static function appSenderFormatText(tf:TextField, str:String, isSelf:Boolean) : void
      {
         if(isSelf)
         {
            _tfm.color = 255;
         }
         else
         {
            _tfm.color = 32768;
         }
         _tfm.bold = false;
         _tfm.size = 12;
         _tfm.italic = false;
         _tfm.underline = false;
         appendOne(tf,str);
      }
      
      public static function appSeparatorFormatText(tf:TextField, str:String, color:uint) : void
      {
         _tfm.color = color;
         _tfm.bold = true;
         _tfm.size = 12;
         _tfm.italic = false;
         _tfm.underline = false;
         appendOne(tf,str);
      }
      
      public static function getEventTxt(str:String, href:String) : String
      {
         return "<a href=\'event:" + href + "\'><font color=\'#FF0000\'>" + str + "</font></a>";
      }
      
      public static function getRedTxt(str:String) : String
      {
         return "<font color=\'#FF0000\'>" + str + "</font>";
      }
      
      public static function getBlueTxt(str:String) : String
      {
         return "<font color=\'#0000FF\'>" + str + "</font>";
      }
      
      private static function appendOne(tf:TextField, str:String) : void
      {
         tf.replaceText(tf.length,tf.length + 1,str);
         tf.setTextFormat(_tfm,tf.length - str.length,tf.length);
      }
   }
}

