package com.robot.core.config.xml
{
   import flash.utils.getDefinitionByName;
   
   public class TaskConditionListInfo
   {
      private var _fun:String;
      
      private var _args:String;
      
      private var _xml:XML;
      
      private var _error:String;
      
      public function TaskConditionListInfo(xml:XML)
      {
         super();
         this._xml = xml;
         this._fun = xml.@fun;
         this._args = xml.@arg;
         this._error = xml;
      }
      
      public function getClass() : Class
      {
         if(this._xml["class"] != "")
         {
            return getDefinitionByName(this._xml.attribute["class"]) as Class;
         }
         return getDefinitionByName("com.robot.app.taskPanel.TaskCondition") as Class;
      }
      
      public function get fun() : String
      {
         return this._fun;
      }
      
      public function get args() : String
      {
         return this._args;
      }
      
      public function get error() : String
      {
         return this._error;
      }
   }
}

