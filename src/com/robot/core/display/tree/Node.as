package com.robot.core.display.tree
{
   public class Node implements INode
   {
      private var _name:String;
      
      private var _children:Array;
      
      private var _data:*;
      
      private var _parent:INode;
      
      public function Node(name:String, parent:INode, data:* = null)
      {
         super();
         this._name = name;
         this._parent = parent;
         this._data = data;
      }
      
      public function get children() : Array
      {
         if(this._children == null)
         {
            return new Array();
         }
         return this._children;
      }
      
      public function addChild(n:INode) : INode
      {
         if(this._children == null)
         {
            this._children = new Array();
         }
         this._children.push(n);
         return n;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(data:*) : void
      {
         this._data = data;
      }
      
      public function get layer() : uint
      {
         return this.parent != null ? uint(this._parent.layer + 1) : 0;
      }
      
      public function get parent() : INode
      {
         return this._parent;
      }
      
      public function set parent(p:INode) : void
      {
         this._parent = p;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function finalize() : void
      {
         var child:INode = null;
         for each(child in this._children)
         {
            child.finalize();
         }
         this._children = null;
         this._data = null;
         this._parent = null;
      }
      
      public function toString() : String
      {
         var parentId:String = this.parent != null ? this._parent.name : null;
         return "Node name " + this.name + " parent id " + parentId + " layer " + this.layer + " data " + this.data;
      }
   }
}

