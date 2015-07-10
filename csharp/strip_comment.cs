 /* 
    C# script to strip comment
    This code extracts comment from a line of string (a sql file in this context). 
    Feeding a stream of lines to it, it concatenates the comment and non-comment parts and return them. 
    Comment is defined by "/** /" or "//" as in C/C++.
    
    @Author: X. Chen
    @Created on: February 17, 2011
 */


    /// <summary>
    /// Input: line.
    /// Output: 
    ///   rStr - The non-comment part is concatenated to rStr.
    ///   rCmt - The comment part is concatenated to rCmt.
    /// </summary>
    private void stripComment(string line, ref string rStr, ref string rCmt)
    {
        bool debug = false;
        bool comment_block = false, comment_line = false;
        int index, index2;
        string NEWLINE = "\r\n";
        string s = "";
        string cmt = "";

        if (line.Trim() == "") return; // ignore empty line.

        string subline = line;
        while (subline.Length > 0)
        {
            // if not in both comments mode:
            //     if find /*, start comment_block from the point on.
            //     elsif find --, start comment_line from here to end of line.
            //     Since both "/*" and "--" may exist on this line, find the one occur first.
            if (comment_block == false)
            {
                index = subline.IndexOf("/*");
                index2 = subline.IndexOf("--");
                if (index != -1 && index2 != -1)
                {
                    if (index < index2) { comment_block = true; }
                    else { comment_line = true; }
                }
                else if (index != -1) { comment_block = true; }
                else if (index2 != -1) { comment_line = true; }

                if (comment_block)
                {
                    // comment_block start found.
                    // print the substring before "/*".
                    if (debug) Console.WriteLine(subline.Substring(0, index));
                    s += subline.Substring(0, index);
                    // strip the first part.
                    subline = subline.Substring(index);
                    continue;
                }
                else if (comment_line)
                {
                    // comment_line found.
                    cmt += subline.Substring(index2) + NEWLINE; // comment part.
                    // print the substring before "--".
                    subline = subline.Substring(0, index2);
                    if (subline.Trim() != "")
                    {
                        if (debug) Console.WriteLine(subline);
                        s += subline + NEWLINE;
                    }
                    comment_line = false;
                    break;
                }
                else
                {
                    // is a normal line.
                    if (subline.Length > 0)
                    {
                        if (debug) Console.WriteLine(subline);
                        s += subline + NEWLINE;
                        break;
                    }
                }

            }
            else
            {
                // $comment_block == 1. In comment_block, 
                // search for */, if found, ends comment_block.
                // Note that in comment_block mode, "--" has no effect.
                index = subline.IndexOf("*/");
                if (index != -1)
                {
                    cmt += subline.Substring(0, index + 2); // comment part.
                    comment_block = false;
                    if (debug) Console.WriteLine("comment_block end found.");
                    subline = subline.Substring(index + 2);
                    continue;
                }
                else
                {
                    // entire line is in comment_block.
                    cmt += subline; // comment part.
                    if (subline != line)
                    {
                        if (debug) Console.WriteLine(NEWLINE);
                        s += NEWLINE;
                        cmt += NEWLINE; // comment part.
                    }
                    break;
                }
            }

        }

        rStr += s; 
        rCmt += cmt; 
    }
