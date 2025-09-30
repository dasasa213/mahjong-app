<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/user" %>

<u:layout title="利用者ホーム" active="home">

  <style>
    .home-section { margin: 20px 0; }
    .home-section h2 { margin-bottom: 10px; font-size: 1.2em; border-left: 4px solid #2e7d32; padding-left: 6px; }
    .home-list { list-style: none; padding: 0; }
    .home-list li { margin: 8px 0; }
    .home-list li span { font-weight: bold; }
  </style>

  <div>
    <h1>ようこそ、${sessionScope.userName} さん！</h1>
    <p>ここは利用者ホーム画面です。</p>

    <div class="home-section">
      <h2>できること</h2>
      <ul class="home-list">
        <li><span>新規対局</span> : 新しい半荘を登録できます。</li>
        <li><span>対局編集</span> : 過去に登録した対局を修正できます。</li>
        <li><span>総合成績</span> : グループ全体の成績を確認できます。</li>
      </ul>
    </div>

    <div class="home-section">
      <h2>ご案内</h2>
      <p>メニューから機能を選んで操作してください。<br>
         各ページの内容は自動的に保存されるわけではありませんので、必ず「登録」ボタンで保存を行ってください。</p>
    </div>

    <div class="home-section">
      <h2>今後のアップデート予定</h2>
      <ul class="home-list">
        <li>成績をグラフで表示する機能</li>
        <li>月別・年別の集計表示</li>
      </ul>
    </div>
  </div>
</u:layout>
