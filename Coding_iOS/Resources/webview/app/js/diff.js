'use strict';
var htmlEscape = function (content) {
  var div = document.createElement('div');
  div.appendChild(document.createTextNode(content));
  return div.innerHTML;
};
var diff = function (data) {
  if (!data || !data.diffLines) {
    return '<div class="diff" style="border: none">' + data + '</div>';
  }
  var html = [];
  html.push('<div class="diff">');
  var noDiff = '<table><tbody><tr><td><pre>无内容变化</pre></td></tr></tbody></table>';
  var noPreview = '<table><tbody><tr><td><pre>不支持预览此文件</pre></td></tr></tbody></table>';
  if (data.fileType === 'image') {
    if (data.changeType && (data.changeType === 'delete' || data.changeType === 'add' )) {
      html.push('<div class="image-' + data.changeType + '"><img src="' + data.image + '"></div>')
    } else {
      html.push(noDiff);
    }
  } else if (data.fileType === 'binary') {
     html.push(noPreview);
  } else {
    var diffLines = data.diffLines;
    if (diffLines.length === 0) {
      html.push(noDiff);
      html.push('</div>');
      return html.join('');
    }
    html.push('<table><tbody>');
    $.each(diffLines, function (i, diffLine) {
      var prefixClass = 'ge';
      if (diffLine.prefix === '+') {
        prefixClass = 'gi';
      } else if (diffLine.prefix === '-') {
        prefixClass = 'gd';
      } else if (diffLine.rightNo === 0 && diffLine.leftNo === 0) {
        prefixClass = 'gc';
      }
      html.push('<tr data-index="'+i+'">');
      if (prefixClass === 'gc') {
        html.push('<td class="diff-line-num '+prefixClass+'">...</td>');
        html.push('<td class="diff-line-num '+prefixClass+'">...</td>');
      } else if (prefixClass === 'gi') {
        html.push('<td class="diff-line-num '+prefixClass+'" ></td>');
        html.push('<td class="diff-line-num '+prefixClass+'" line-data="'+diffLine.rightNo+'"></td>');
      } else if (prefixClass === 'gd') {
        html.push('<td class="diff-line-num '+prefixClass+'" line-data="'+diffLine.leftNo+'"></td>');
        html.push('<td class="diff-line-num '+prefixClass+'" ></td>');
      } else {
        html.push('<td class="diff-line-num '+prefixClass+'" line-data="'+diffLine.leftNo+'"></td>');
        html.push('<td class="diff-line-num '+prefixClass+'" line-data="'+diffLine.rightNo+'"></td>');
      }
      html.push('<td class="diff-line-code '+prefixClass+'"><pre>'+htmlEscape(diffLine.text)+'</pre></td>');
      html.push('</tr>');
    });
    html.push('</table></tbody>');
  }
  html.push('</div>');
  return html.join('');
};
$(function() {
  var diffContent = $('#diff-content');
  //var data = ${diff-content};
  var data = "";
  diffContent.html(diff(data.data));
});

