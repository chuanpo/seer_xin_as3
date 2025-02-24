package com.robot.core.display.tree
{
   public class StatefulNode extends Node
   {
      private var _open:Boolean = false;
      
      private var _closed:Boolean;
      
      private var _isNewAndUN:Boolean = false;
      
      private var _isClick:Boolean = false;
      
      public function StatefulNode(name:String, parent:INode, data:* = null)
      {
         super(name,parent,data);
      }
      
      public function hasOpenChilds() : Boolean
      {
         var node:StatefulNode = null;
         for each(node in children)
         {
            if(node.isOpen())
            {
               return true;
            }
         }
         return false;
      }
      
      public function hasIsNewAndUNChilds() : Boolean
      {
         var node:StatefulNode = null;
         for each(node in children)
         {
            if(node.isNewAndUN)
            {
               return true;
            }
         }
         return false;
      }
      
      public function setClosed(closed:Boolean) : void
      {
         this._closed = closed;
      }
      
      public function isClosed() : Boolean
      {
         return this._closed;
      }
      
      public function setOpen(open:Boolean) : void
      {
         this._open = open;
      }
      
      public function isOpen() : Boolean
      {
         return this._open;
      }
      
      public function set isNewAndUN(value:Boolean) : void
      {
         this._isNewAndUN = value;
      }
      
      public function get isNewAndUN() : Boolean
      {
         return this._isNewAndUN;
      }
      
      public function set isClick(value:Boolean) : void
      {
         this._isClick = value;
      }
      
      public function get isClick() : Boolean
      {
         return this._isClick;
      }
   }
}

