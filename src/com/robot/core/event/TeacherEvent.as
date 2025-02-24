package com.robot.core.event
{
   import com.robot.core.info.InformInfo;
   import flash.events.Event;
   
   public class TeacherEvent extends Event
   {
      public static const REQUEST_ME_AS_TEACHER:String = "requestMeAsTeacher";
      
      public static const REQUEST_TEACHER_HANDLED:String = "requestTeacherHandled";
      
      public static const REQUEST_ME_AS_STUDENT:String = "requestMeAsStudent";
      
      public static const REQUEST_STUDENT_HANDLED:String = "requestStudentHandled";
      
      public static const DELETE_AS_TEACHER:String = "deleteAsTeacher";
      
      public static const DELETE_AS_STUDENT:String = "deleteAsStudent";
      
      private var _info:InformInfo;
      
      public function TeacherEvent(type:String, _info:InformInfo, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._info = _info;
      }
      
      public function get info() : InformInfo
      {
         return this._info;
      }
   }
}

