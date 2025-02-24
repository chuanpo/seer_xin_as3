package com.robot.core.event
{
   import flash.events.Event;
   
   public class MailEvent extends Event
   {
      public static const MAIL_LIST:String = "mailList";
      
      public static const MAIL_DELETE:String = "mailDelete";
      
      public static const MAIL_CLEAR:String = "mailClear";
      
      public static const MAIL_SEND:String = "mailSend";
      
      public function MailEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

