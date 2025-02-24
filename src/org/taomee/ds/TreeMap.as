package org.taomee.ds
{
   public class TreeMap implements ITree
   {
      private var _root:TreeMap;
      
      private var _data:*;
      
      private var _parent:TreeMap;
      
      private var _children:HashMap;
      
      private var _key:*;
      
      public function TreeMap(key:*, data:* = null, parent:TreeMap = null)
      {
         super();
         _key = key;
         _data = data;
         _children = new HashMap();
         this.parent = parent;
      }
      
      public function get depth() : int
      {
         if(_parent == null)
         {
            return 0;
         }
         var node:TreeMap = _parent;
         var c:int = 0;
         while(Boolean(node))
         {
            c++;
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeMap Infinite Loop");
            }
         }
         return c;
      }
      
      public function remove() : void
      {
         if(_parent == null)
         {
            return;
         }
         _children.eachValue(function(child:TreeMap):void
         {
            child.parent = _parent;
         });
      }
      
      public function get parent() : TreeMap
      {
         return _parent;
      }
      
      public function clear() : void
      {
         _children = new HashMap();
      }
      
      public function set data(d:*) : void
      {
         _data = d;
      }
      
      public function get numSiblings() : int
      {
         if(Boolean(_parent))
         {
            return _parent.numChildren;
         }
         return 0;
      }
      
      public function get key() : *
      {
         return _key;
      }
      
      public function get root() : TreeMap
      {
         return _root;
      }
      
      public function set parent(parent:TreeMap) : void
      {
         if(Boolean(_parent))
         {
            _parent.children.remove(_key);
         }
         if(parent == this)
         {
            return;
         }
         _parent = parent;
         if(Boolean(_parent))
         {
            _parent.children.add(_key,this);
         }
         setRoot();
      }
      
      private function setRoot() : void
      {
         if(_parent == null)
         {
            _root = this;
            return;
         }
         var node:TreeMap = _parent;
         while(Boolean(node))
         {
            if(node.parent == null)
            {
               _root = node;
               return;
            }
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeMap Infinite Loop");
            }
         }
      }
      
      public function get length() : int
      {
         var c:int = numChildren;
         var node:TreeMap = _parent;
         while(Boolean(node))
         {
            c += node.numChildren;
            node = node.parent;
            if(node == this)
            {
               throw new Error("TreeMap Infinite Loop");
            }
         }
         return c;
      }
      
      public function get isLeaf() : Boolean
      {
         return _children.length == 0;
      }
      
      public function get data() : *
      {
         return _data;
      }
      
      public function get isRoot() : Boolean
      {
         return _root == this;
      }
      
      public function get numChildren() : int
      {
         return _children.length;
      }
      
      public function set key(k:*) : void
      {
         if(Boolean(_parent))
         {
            _parent.children.remove(_key);
            _parent.children.add(k,this);
         }
         _key = k;
      }
      
      public function get children() : HashMap
      {
         return _children;
      }
   }
}

