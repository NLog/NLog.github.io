  


<!DOCTYPE html>
<html>
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# githubog: http://ogp.me/ns/fb/githubog#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>jekyll_alias_generator/_plugins/alias_generator.rb at master · tsmango/jekyll_alias_generator</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub" />
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub" />
    <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-144.png" />
    <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144.png" />
    <link rel="logo" type="image/svg" href="http://github-media-downloads.s3.amazonaws.com/github-logo.svg" />
    <link rel="xhr-socket" href="/_sockets">
    <meta name="msapplication-TileImage" content="/windows-tile.png">
    <meta name="msapplication-TileColor" content="#ffffff">

    
    
    <link rel="icon" type="image/x-icon" href="/favicon.ico" />

    <meta content="authenticity_token" name="csrf-param" />
<meta content="wkg6eosmss3z8dS9nA3QDIW61BQq6MM9gUFb6V0iM6o=" name="csrf-token" />

    <link href="https://a248.e.akamai.net/assets.github.com/assets/github-f2fa2051cd27f4f2a4611989f6f08acbd564f722.css" media="all" rel="stylesheet" type="text/css" />
    <link href="https://a248.e.akamai.net/assets.github.com/assets/github2-c15137b0b05c94db05fa047ecd589d7a7df41d85.css" media="all" rel="stylesheet" type="text/css" />
    


      <script src="https://a248.e.akamai.net/assets.github.com/assets/frameworks-010d500708696b4ecee44478b5229d626367e844.js" type="text/javascript"></script>
      <script src="https://a248.e.akamai.net/assets.github.com/assets/github-d0f76964f2a7dfb9b87493f279d45019ffeeec05.js" type="text/javascript"></script>
      
      <meta http-equiv="x-pjax-version" content="9eb9887f8b7320396fe0fba7deffdde9">

        <link data-pjax-transient rel='permalink' href='/tsmango/jekyll_alias_generator/blob/0e7fd23bae93c5297f00fa13fbd9cc985a553f4b/_plugins/alias_generator.rb'>
    <meta property="og:title" content="jekyll_alias_generator"/>
    <meta property="og:type" content="githubog:gitrepository"/>
    <meta property="og:url" content="https://github.com/tsmango/jekyll_alias_generator"/>
    <meta property="og:image" content="https://secure.gravatar.com/avatar/2a34c68022ae45d335c77b6ffc412a2f?s=420&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"/>
    <meta property="og:site_name" content="GitHub"/>
    <meta property="og:description" content="jekyll_alias_generator - A Jekyll plugin for generating redirect pages for posts."/>
    <meta property="twitter:card" content="summary"/>
    <meta property="twitter:site" content="@GitHub">
    <meta property="twitter:title" content="tsmango/jekyll_alias_generator"/>

    <meta name="description" content="jekyll_alias_generator - A Jekyll plugin for generating redirect pages for posts." />

  <link href="https://github.com/tsmango/jekyll_alias_generator/commits/master.atom" rel="alternate" title="Recent Commits to jekyll_alias_generator:master" type="application/atom+xml" />

  </head>


  <body class="logged_in page-blob windows vis-public env-production  ">
    <div id="wrapper">

      

      
      
      

      <div class="header header-logged-in true">
  <div class="container clearfix">

    <a class="header-logo-invertocat" href="https://github.com/">
  <span class="mega-icon mega-icon-invertocat"></span>
</a>

    <div class="divider-vertical"></div>

      <a href="/notifications" class="notification-indicator tooltipped downwards" title="You have no unread notifications">
    <span class="mail-status all-read"></span>
  </a>
  <div class="divider-vertical"></div>


      <div class="command-bar js-command-bar  ">
            <form accept-charset="UTF-8" action="/search" class="command-bar-form" id="top_search_form" method="get">
  <a href="/search/advanced" class="advanced-search-icon tooltipped downwards command-bar-search" id="advanced_search" title="Advanced search"><span class="mini-icon mini-icon-advanced-search "></span></a>

  <input type="text" data-hotkey="/ s" name="q" id="js-command-bar-field" placeholder="Search or type a command" tabindex="1" data-username="Xharze" autocapitalize="off">

  <span class="mini-icon help tooltipped downwards" title="Show command bar help">
    <span class="mini-icon mini-icon-help"></span>
  </span>

  <input type="hidden" name="ref" value="cmdform">

    <input type="hidden" class="js-repository-name-with-owner" value="tsmango/jekyll_alias_generator"/>
    <input type="hidden" class="js-repository-branch" value="master"/>
    <input type="hidden" class="js-repository-tree-sha" value="0064a48107a213e3e186dd806952a8ef917cf8c9"/>

  <div class="divider-vertical"></div>
</form>
        <ul class="top-nav">
            <li class="explore"><a href="https://github.com/explore">Explore</a></li>
            <li><a href="https://gist.github.com">Gist</a></li>
            <li><a href="/blog">Blog</a></li>
          <li><a href="http://help.github.com">Help</a></li>
        </ul>
      </div>

    

  

    <ul id="user-links">
      <li>
        <a href="https://github.com/Xharze" class="name">
          <img height="20" src="https://secure.gravatar.com/avatar/a03f4d56e65571977ce1b5eb270b46e3?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /> Xharze
        </a>
      </li>

        <li>
          <a href="/new" id="new_repo" class="tooltipped downwards" title="Create a new repo">
            <span class="mini-icon mini-icon-create"></span>
          </a>
        </li>

        <li>
          <a href="/settings/profile" id="account_settings"
            class="tooltipped downwards"
            title="Account settings ">
            <span class="mini-icon mini-icon-account-settings"></span>
          </a>
        </li>
        <li>
          <a class="tooltipped downwards" href="/logout" data-method="post" id="logout" title="Sign out">
            <span class="mini-icon mini-icon-logout"></span>
          </a>
        </li>

    </ul>


<div class="js-new-dropdown-contents hidden">
  <ul class="dropdown-menu">
    <li>
      <a href="/new"><span class="mini-icon mini-icon-create"></span> New repository</a>
    </li>
    <li>
        <a href="https://github.com/tsmango/jekyll_alias_generator/issues/new"><span class="mini-icon mini-icon-issue-opened"></span> New issue</a>
    </li>
    <li>
    </li>
    <li>
      <a href="/organizations/new"><span class="mini-icon mini-icon-u-list"></span> New organization</a>
    </li>
  </ul>
</div>


    
  </div>
</div>

      

      

      


            <div class="site hfeed" itemscope itemtype="http://schema.org/WebPage">
      <div class="hentry">
        
        <div class="pagehead repohead instapaper_ignore readability-menu ">
          <div class="container">
            <div class="title-actions-bar">
              


<ul class="pagehead-actions">


    <li class="subscription">
      <form accept-charset="UTF-8" action="/notifications/subscribe" data-autosubmit="true" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="wkg6eosmss3z8dS9nA3QDIW61BQq6MM9gUFb6V0iM6o=" /></div>  <input id="repository_id" name="repository_id" type="hidden" value="2275799" />

    <div class="select-menu js-menu-container js-select-menu">
      <span class="minibutton select-menu-button js-menu-target">
        <span class="js-select-button">
          <span class="mini-icon mini-icon-watching"></span>
          Watch
        </span>
      </span>

      <div class="select-menu-modal-holder js-menu-content">
        <div class="select-menu-modal">
          <div class="select-menu-header">
            <span class="select-menu-title">Notification status</span>
            <span class="mini-icon mini-icon-remove-close js-menu-close"></span>
          </div> <!-- /.select-menu-header -->

          <div class="select-menu-list js-navigation-container">

            <div class="select-menu-item js-navigation-item js-navigation-target selected">
              <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
              <div class="select-menu-item-text">
                <input checked="checked" id="do_included" name="do" type="radio" value="included" />
                <h4>Not watching</h4>
                <span class="description">You only receive notifications for discussions in which you participate or are @mentioned.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="mini-icon mini-icon-watching"></span>
                  Watch
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

            <div class="select-menu-item js-navigation-item js-navigation-target ">
              <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
              <div class="select-menu-item-text">
                <input id="do_subscribed" name="do" type="radio" value="subscribed" />
                <h4>Watching</h4>
                <span class="description">You receive notifications for all discussions in this repository.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="mini-icon mini-icon-unwatch"></span>
                  Unwatch
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

            <div class="select-menu-item js-navigation-item js-navigation-target ">
              <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
              <div class="select-menu-item-text">
                <input id="do_ignore" name="do" type="radio" value="ignore" />
                <h4>Ignoring</h4>
                <span class="description">You do not receive any notifications for discussions in this repository.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="mini-icon mini-icon-mute"></span>
                  Stop ignoring
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

          </div> <!-- /.select-menu-list -->

        </div> <!-- /.select-menu-modal -->
      </div> <!-- /.select-menu-modal-holder -->
    </div> <!-- /.select-menu -->

</form>
    </li>

    <li class="js-toggler-container js-social-container starring-container ">
      <a href="/tsmango/jekyll_alias_generator/unstar" class="minibutton js-toggler-target star-button starred upwards" title="Unstar this repo" data-remote="true" data-method="post" rel="nofollow">
        <span class="mini-icon mini-icon-remove-star"></span>
        <span class="text">Unstar</span>
      </a>
      <a href="/tsmango/jekyll_alias_generator/star" class="minibutton js-toggler-target star-button unstarred upwards" title="Star this repo" data-remote="true" data-method="post" rel="nofollow">
        <span class="mini-icon mini-icon-star"></span>
        <span class="text">Star</span>
      </a>
      <a class="social-count js-social-count" href="/tsmango/jekyll_alias_generator/stargazers">40</a>
    </li>

        <li>
          <a href="/tsmango/jekyll_alias_generator/fork_select" class="minibutton js-toggler-target fork-button lighter upwards" title="Fork this repo" rel="facebox nofollow">
            <span class="mini-icon mini-icon-branch-create"></span>
            <span class="text">Fork</span>
          </a>
          <a href="/tsmango/jekyll_alias_generator/network" class="social-count">15</a>
        </li>


</ul>

              <h1 itemscope itemtype="http://data-vocabulary.org/Breadcrumb" class="entry-title public">
                <span class="repo-label"><span>public</span></span>
                <span class="mega-icon mega-icon-public-repo"></span>
                <span class="author vcard">
                  <a href="/tsmango" class="url fn" itemprop="url" rel="author">
                  <span itemprop="title">tsmango</span>
                  </a></span> /
                <strong><a href="/tsmango/jekyll_alias_generator" class="js-current-repository">jekyll_alias_generator</a></strong>
              </h1>
            </div>

            
  <ul class="tabs">
    <li><a href="/tsmango/jekyll_alias_generator" class="selected" highlight="repo_source repo_downloads repo_commits repo_tags repo_branches">Code</a></li>
    <li><a href="/tsmango/jekyll_alias_generator/network" highlight="repo_network">Network</a></li>
    <li><a href="/tsmango/jekyll_alias_generator/pulls" highlight="repo_pulls">Pull Requests <span class='counter'>0</span></a></li>

      <li><a href="/tsmango/jekyll_alias_generator/issues" highlight="repo_issues">Issues <span class='counter'>0</span></a></li>

      <li><a href="/tsmango/jekyll_alias_generator/wiki" highlight="repo_wiki">Wiki</a></li>


    <li><a href="/tsmango/jekyll_alias_generator/graphs" highlight="repo_graphs repo_contributors">Graphs</a></li>


  </ul>
  
<div class="tabnav">

  <span class="tabnav-right">
    <ul class="tabnav-tabs">
          <li><a href="/tsmango/jekyll_alias_generator/tags" class="tabnav-tab" highlight="repo_tags">Tags <span class="counter blank">0</span></a></li>
    </ul>
    
  </span>

  <div class="tabnav-widget scope">


    <div class="select-menu js-menu-container js-select-menu js-branch-menu">
      <a class="minibutton select-menu-button js-menu-target" data-hotkey="w" data-ref="master">
        <span class="mini-icon mini-icon-branch"></span>
        <i>branch:</i>
        <span class="js-select-button">master</span>
      </a>

      <div class="select-menu-modal-holder js-menu-content js-navigation-container">

        <div class="select-menu-modal">
          <div class="select-menu-header">
            <span class="select-menu-title">Switch branches/tags</span>
            <span class="mini-icon mini-icon-remove-close js-menu-close"></span>
          </div> <!-- /.select-menu-header -->

          <div class="select-menu-filters">
            <div class="select-menu-text-filter">
              <input type="text" id="commitish-filter-field" class="js-filterable-field js-navigation-enable" placeholder="Filter branches/tags">
            </div>
            <div class="select-menu-tabs">
              <ul>
                <li class="select-menu-tab">
                  <a href="#" data-tab-filter="branches" class="js-select-menu-tab">Branches</a>
                </li>
                <li class="select-menu-tab">
                  <a href="#" data-tab-filter="tags" class="js-select-menu-tab">Tags</a>
                </li>
              </ul>
            </div><!-- /.select-menu-tabs -->
          </div><!-- /.select-menu-filters -->

          <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket css-truncate" data-tab-filter="branches">

            <div data-filterable-for="commitish-filter-field" data-filterable-type="substring">

                <div class="select-menu-item js-navigation-item js-navigation-target selected">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/tsmango/jekyll_alias_generator/blob/master/_plugins/alias_generator.rb" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="master" rel="nofollow" title="master">master</a>
                </div> <!-- /.select-menu-item -->
            </div>

              <div class="select-menu-no-results">Nothing to show</div>
          </div> <!-- /.select-menu-list -->


          <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket css-truncate" data-tab-filter="tags">
            <div data-filterable-for="commitish-filter-field" data-filterable-type="substring">

            </div>

            <div class="select-menu-no-results">Nothing to show</div>

          </div> <!-- /.select-menu-list -->

        </div> <!-- /.select-menu-modal -->
      </div> <!-- /.select-menu-modal-holder -->
    </div> <!-- /.select-menu -->

  </div> <!-- /.scope -->

  <ul class="tabnav-tabs">
    <li><a href="/tsmango/jekyll_alias_generator" class="selected tabnav-tab" highlight="repo_source">Files</a></li>
    <li><a href="/tsmango/jekyll_alias_generator/commits/master" class="tabnav-tab" highlight="repo_commits">Commits</a></li>
    <li><a href="/tsmango/jekyll_alias_generator/branches" class="tabnav-tab" highlight="repo_branches" rel="nofollow">Branches <span class="counter ">1</span></a></li>
  </ul>

</div>

  
  
  


            
          </div>
        </div><!-- /.repohead -->

        <div id="js-repo-pjax-container" class="container context-loader-container" data-pjax-container>
          


<!-- blob contrib key: blob_contributors:v21:7ca39f2e09df1b3a2041f127a4db6809 -->
<!-- blob contrib frag key: views10/v8/blob_contributors:v21:7ca39f2e09df1b3a2041f127a4db6809 -->


<div id="slider">
    <div class="frame-meta">

      <p title="This is a placeholder element" class="js-history-link-replace hidden"></p>

        <div class="breadcrumb">
          <span class='bold'><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/tsmango/jekyll_alias_generator" class="js-slide-to" data-branch="master" data-direction="back" itemscope="url"><span itemprop="title">jekyll_alias_generator</span></a></span></span><span class="separator"> / </span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/tsmango/jekyll_alias_generator/tree/master/_plugins" class="js-slide-to" data-branch="master" data-direction="back" itemscope="url"><span itemprop="title">_plugins</span></a></span><span class="separator"> / </span><strong class="final-path">alias_generator.rb</strong> <span class="js-zeroclipboard zeroclipboard-button" data-clipboard-text="_plugins/alias_generator.rb" data-copied-hint="copied!" title="copy to clipboard"><span class="mini-icon mini-icon-clipboard"></span></span>
        </div>

      <a href="/tsmango/jekyll_alias_generator/find/master" class="js-slide-to" data-hotkey="t" style="display:none">Show File Finder</a>


        
  <div class="commit file-history-tease">
    <img class="main-avatar" height="24" src="https://secure.gravatar.com/avatar/2a34c68022ae45d335c77b6ffc412a2f?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
    <span class="author"><a href="/tsmango" rel="author">tsmango</a></span>
    <time class="js-relative-date" datetime="2012-07-24T14:15:23-07:00" title="2012-07-24 14:15:23">July 24, 2012</time>
    <div class="commit-title">
        <a href="/tsmango/jekyll_alias_generator/commit/0e7fd23bae93c5297f00fa13fbd9cc985a553f4b" class="message">Resolved an issue where an alias couldn't be just a number. Closes</a> <a href="https://github.com/tsmango/jekyll_alias_generator/issues/6" class="issue-link" title="If alias is a number, ruby gets confused -- can't convert Fixnum into String (TypeError)">#6</a><a href="/tsmango/jekyll_alias_generator/commit/0e7fd23bae93c5297f00fa13fbd9cc985a553f4b" class="message">.</a>
    </div>

    <div class="participation">
      <p class="quickstat"><a href="#blob_contributors_box" rel="facebox"><strong>6</strong> contributors</a></p>
          <a class="avatar tooltipped downwards" title="tsmango" href="/tsmango/jekyll_alias_generator/commits/master/_plugins/alias_generator.rb?author=tsmango"><img height="20" src="https://secure.gravatar.com/avatar/2a34c68022ae45d335c77b6ffc412a2f?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>
    <a class="avatar tooltipped downwards" title="latish" href="/tsmango/jekyll_alias_generator/commits/master/_plugins/alias_generator.rb?author=latish"><img height="20" src="https://secure.gravatar.com/avatar/2a40aef5d2e97619610b60b87defc38f?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>
    <a class="avatar tooltipped downwards" title="sstarr" href="/tsmango/jekyll_alias_generator/commits/master/_plugins/alias_generator.rb?author=sstarr"><img height="20" src="https://secure.gravatar.com/avatar/1dcda1ce80dae11b34646a9f0af655dc?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>
    <a class="avatar tooltipped downwards" title="joliss" href="/tsmango/jekyll_alias_generator/commits/master/_plugins/alias_generator.rb?author=joliss"><img height="20" src="https://secure.gravatar.com/avatar/4d6f74711436cfe252bf4fc8f3cf4971?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>
    <a class="avatar tooltipped downwards" title="rawsyntax" href="/tsmango/jekyll_alias_generator/commits/master/_plugins/alias_generator.rb?author=rawsyntax"><img height="20" src="https://secure.gravatar.com/avatar/c1f2c418f2e87d63e2ccbf538ed70fdb?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>
    <a class="avatar tooltipped downwards" title="christophermaier" href="/tsmango/jekyll_alias_generator/commits/master/_plugins/alias_generator.rb?author=christophermaier"><img height="20" src="https://secure.gravatar.com/avatar/b6b298a0466b6e402fff86fc5bf0b818?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>


    </div>
    <div id="blob_contributors_box" style="display:none">
      <h2>Users on GitHub who have contributed to this file</h2>
      <ul class="facebox-user-list">
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/2a34c68022ae45d335c77b6ffc412a2f?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/tsmango">tsmango</a>
        </li>
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/2a40aef5d2e97619610b60b87defc38f?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/latish">latish</a>
        </li>
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/1dcda1ce80dae11b34646a9f0af655dc?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/sstarr">sstarr</a>
        </li>
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/4d6f74711436cfe252bf4fc8f3cf4971?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/joliss">joliss</a>
        </li>
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/c1f2c418f2e87d63e2ccbf538ed70fdb?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/rawsyntax">rawsyntax</a>
        </li>
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/b6b298a0466b6e402fff86fc5bf0b818?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/christophermaier">christophermaier</a>
        </li>
      </ul>
    </div>
  </div>


    </div><!-- ./.frame-meta -->

    <div class="frames">
      <div class="frame" data-permalink-url="/tsmango/jekyll_alias_generator/blob/0e7fd23bae93c5297f00fa13fbd9cc985a553f4b/_plugins/alias_generator.rb" data-title="jekyll_alias_generator/_plugins/alias_generator.rb at master · tsmango/jekyll_alias_generator · GitHub" data-type="blob">

        <div id="files" class="bubble">
          <div class="file">
            <div class="meta">
              <div class="info">
                <span class="icon"><b class="mini-icon mini-icon-text-file"></b></span>
                <span class="mode" title="File Mode">file</span>
                  <span>109 lines (90 sloc)</span>
                <span>2.809 kb</span>
              </div>
              <div class="actions">
                <div class="button-group">
                        <a class="minibutton tooltipped leftwards"
                           title="Clicking this button will automatically fork this project so you can edit the file"
                           href="/tsmango/jekyll_alias_generator/edit/master/_plugins/alias_generator.rb"
                           data-method="post" rel="nofollow">Edit</a>
                  <a href="/tsmango/jekyll_alias_generator/raw/master/_plugins/alias_generator.rb" class="button minibutton " id="raw-url">Raw</a>
                    <a href="/tsmango/jekyll_alias_generator/blame/master/_plugins/alias_generator.rb" class="button minibutton ">Blame</a>
                  <a href="/tsmango/jekyll_alias_generator/commits/master/_plugins/alias_generator.rb" class="button minibutton " rel="nofollow">History</a>
                </div><!-- /.button-group -->
              </div><!-- /.actions -->

            </div>
                <div class="blob-wrapper data type-ruby js-blob-data">
      <table class="file-code file-diff">
        <tr class="file-code-line">
          <td class="blob-line-nums">
            <span id="L1" rel="#L1">1</span>
<span id="L2" rel="#L2">2</span>
<span id="L3" rel="#L3">3</span>
<span id="L4" rel="#L4">4</span>
<span id="L5" rel="#L5">5</span>
<span id="L6" rel="#L6">6</span>
<span id="L7" rel="#L7">7</span>
<span id="L8" rel="#L8">8</span>
<span id="L9" rel="#L9">9</span>
<span id="L10" rel="#L10">10</span>
<span id="L11" rel="#L11">11</span>
<span id="L12" rel="#L12">12</span>
<span id="L13" rel="#L13">13</span>
<span id="L14" rel="#L14">14</span>
<span id="L15" rel="#L15">15</span>
<span id="L16" rel="#L16">16</span>
<span id="L17" rel="#L17">17</span>
<span id="L18" rel="#L18">18</span>
<span id="L19" rel="#L19">19</span>
<span id="L20" rel="#L20">20</span>
<span id="L21" rel="#L21">21</span>
<span id="L22" rel="#L22">22</span>
<span id="L23" rel="#L23">23</span>
<span id="L24" rel="#L24">24</span>
<span id="L25" rel="#L25">25</span>
<span id="L26" rel="#L26">26</span>
<span id="L27" rel="#L27">27</span>
<span id="L28" rel="#L28">28</span>
<span id="L29" rel="#L29">29</span>
<span id="L30" rel="#L30">30</span>
<span id="L31" rel="#L31">31</span>
<span id="L32" rel="#L32">32</span>
<span id="L33" rel="#L33">33</span>
<span id="L34" rel="#L34">34</span>
<span id="L35" rel="#L35">35</span>
<span id="L36" rel="#L36">36</span>
<span id="L37" rel="#L37">37</span>
<span id="L38" rel="#L38">38</span>
<span id="L39" rel="#L39">39</span>
<span id="L40" rel="#L40">40</span>
<span id="L41" rel="#L41">41</span>
<span id="L42" rel="#L42">42</span>
<span id="L43" rel="#L43">43</span>
<span id="L44" rel="#L44">44</span>
<span id="L45" rel="#L45">45</span>
<span id="L46" rel="#L46">46</span>
<span id="L47" rel="#L47">47</span>
<span id="L48" rel="#L48">48</span>
<span id="L49" rel="#L49">49</span>
<span id="L50" rel="#L50">50</span>
<span id="L51" rel="#L51">51</span>
<span id="L52" rel="#L52">52</span>
<span id="L53" rel="#L53">53</span>
<span id="L54" rel="#L54">54</span>
<span id="L55" rel="#L55">55</span>
<span id="L56" rel="#L56">56</span>
<span id="L57" rel="#L57">57</span>
<span id="L58" rel="#L58">58</span>
<span id="L59" rel="#L59">59</span>
<span id="L60" rel="#L60">60</span>
<span id="L61" rel="#L61">61</span>
<span id="L62" rel="#L62">62</span>
<span id="L63" rel="#L63">63</span>
<span id="L64" rel="#L64">64</span>
<span id="L65" rel="#L65">65</span>
<span id="L66" rel="#L66">66</span>
<span id="L67" rel="#L67">67</span>
<span id="L68" rel="#L68">68</span>
<span id="L69" rel="#L69">69</span>
<span id="L70" rel="#L70">70</span>
<span id="L71" rel="#L71">71</span>
<span id="L72" rel="#L72">72</span>
<span id="L73" rel="#L73">73</span>
<span id="L74" rel="#L74">74</span>
<span id="L75" rel="#L75">75</span>
<span id="L76" rel="#L76">76</span>
<span id="L77" rel="#L77">77</span>
<span id="L78" rel="#L78">78</span>
<span id="L79" rel="#L79">79</span>
<span id="L80" rel="#L80">80</span>
<span id="L81" rel="#L81">81</span>
<span id="L82" rel="#L82">82</span>
<span id="L83" rel="#L83">83</span>
<span id="L84" rel="#L84">84</span>
<span id="L85" rel="#L85">85</span>
<span id="L86" rel="#L86">86</span>
<span id="L87" rel="#L87">87</span>
<span id="L88" rel="#L88">88</span>
<span id="L89" rel="#L89">89</span>
<span id="L90" rel="#L90">90</span>
<span id="L91" rel="#L91">91</span>
<span id="L92" rel="#L92">92</span>
<span id="L93" rel="#L93">93</span>
<span id="L94" rel="#L94">94</span>
<span id="L95" rel="#L95">95</span>
<span id="L96" rel="#L96">96</span>
<span id="L97" rel="#L97">97</span>
<span id="L98" rel="#L98">98</span>
<span id="L99" rel="#L99">99</span>
<span id="L100" rel="#L100">100</span>
<span id="L101" rel="#L101">101</span>
<span id="L102" rel="#L102">102</span>
<span id="L103" rel="#L103">103</span>
<span id="L104" rel="#L104">104</span>
<span id="L105" rel="#L105">105</span>
<span id="L106" rel="#L106">106</span>
<span id="L107" rel="#L107">107</span>
<span id="L108" rel="#L108">108</span>

          </td>
          <td class="blob-line-code">
                  <div class="highlight"><pre><div class='line' id='LC1'><span class="c1"># Alias Generator for Posts.</span></div><div class='line' id='LC2'><span class="c1">#</span></div><div class='line' id='LC3'><span class="c1"># Generates redirect pages for posts with aliases set in the YAML Front Matter.</span></div><div class='line' id='LC4'><span class="c1">#</span></div><div class='line' id='LC5'><span class="c1"># Place the full path of the alias (place to redirect from) inside the</span></div><div class='line' id='LC6'><span class="c1"># destination post&#39;s YAML Front Matter. One or more aliases may be given.</span></div><div class='line' id='LC7'><span class="c1">#</span></div><div class='line' id='LC8'><span class="c1"># Example Post Configuration:</span></div><div class='line' id='LC9'><span class="c1">#</span></div><div class='line' id='LC10'><span class="c1">#   ---</span></div><div class='line' id='LC11'><span class="c1">#     layout: post</span></div><div class='line' id='LC12'><span class="c1">#     title: &quot;How I Keep Limited Pressing Running&quot;</span></div><div class='line' id='LC13'><span class="c1">#     alias: /post/6301645915/how-i-keep-limited-pressing-running/index.html</span></div><div class='line' id='LC14'><span class="c1">#   ---</span></div><div class='line' id='LC15'><span class="c1">#</span></div><div class='line' id='LC16'><span class="c1"># Example Post Configuration:</span></div><div class='line' id='LC17'><span class="c1">#</span></div><div class='line' id='LC18'><span class="c1">#   ---</span></div><div class='line' id='LC19'><span class="c1">#     layout: post</span></div><div class='line' id='LC20'><span class="c1">#     title: &quot;How I Keep Limited Pressing Running&quot;</span></div><div class='line' id='LC21'><span class="c1">#     alias: [/first-alias/index.html, /second-alias/index.html]</span></div><div class='line' id='LC22'><span class="c1">#   ---</span></div><div class='line' id='LC23'><span class="c1">#</span></div><div class='line' id='LC24'><span class="c1"># Author: Thomas Mango</span></div><div class='line' id='LC25'><span class="c1"># Site: http://thomasmango.com</span></div><div class='line' id='LC26'><span class="c1"># Plugin Source: http://github.com/tsmango/jekyll_alias_generator</span></div><div class='line' id='LC27'><span class="c1"># Site Source: http://github.com/tsmango/thomasmango.com</span></div><div class='line' id='LC28'><span class="c1"># PLugin License: MIT</span></div><div class='line' id='LC29'><br/></div><div class='line' id='LC30'><span class="k">module</span> <span class="nn">Jekyll</span></div><div class='line' id='LC31'><br/></div><div class='line' id='LC32'>&nbsp;&nbsp;<span class="k">class</span> <span class="nc">AliasGenerator</span> <span class="o">&lt;</span> <span class="no">Generator</span></div><div class='line' id='LC33'><br/></div><div class='line' id='LC34'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">def</span> <span class="nf">generate</span><span class="p">(</span><span class="n">site</span><span class="p">)</span></div><div class='line' id='LC35'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="vi">@site</span> <span class="o">=</span> <span class="n">site</span></div><div class='line' id='LC36'><br/></div><div class='line' id='LC37'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">process_posts</span></div><div class='line' id='LC38'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">process_pages</span></div><div class='line' id='LC39'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC40'><br/></div><div class='line' id='LC41'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">def</span> <span class="nf">process_posts</span></div><div class='line' id='LC42'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="vi">@site</span><span class="o">.</span><span class="n">posts</span><span class="o">.</span><span class="n">each</span> <span class="k">do</span> <span class="o">|</span><span class="n">post</span><span class="o">|</span></div><div class='line' id='LC43'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">generate_aliases</span><span class="p">(</span><span class="n">post</span><span class="o">.</span><span class="n">url</span><span class="p">,</span> <span class="n">post</span><span class="o">.</span><span class="n">data</span><span class="o">[</span><span class="s1">&#39;alias&#39;</span><span class="o">]</span><span class="p">)</span></div><div class='line' id='LC44'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC45'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC46'><br/></div><div class='line' id='LC47'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">def</span> <span class="nf">process_pages</span></div><div class='line' id='LC48'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="vi">@site</span><span class="o">.</span><span class="n">pages</span><span class="o">.</span><span class="n">each</span> <span class="k">do</span> <span class="o">|</span><span class="n">page</span><span class="o">|</span></div><div class='line' id='LC49'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">generate_aliases</span><span class="p">(</span><span class="n">page</span><span class="o">.</span><span class="n">destination</span><span class="p">(</span><span class="s1">&#39;&#39;</span><span class="p">)</span><span class="o">.</span><span class="n">gsub</span><span class="p">(</span><span class="sr">/index\.(html|htm)$/</span><span class="p">,</span> <span class="s1">&#39;&#39;</span><span class="p">),</span> <span class="n">page</span><span class="o">.</span><span class="n">data</span><span class="o">[</span><span class="s1">&#39;alias&#39;</span><span class="o">]</span><span class="p">)</span></div><div class='line' id='LC50'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC51'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC52'><br/></div><div class='line' id='LC53'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">def</span> <span class="nf">generate_aliases</span><span class="p">(</span><span class="n">destination_path</span><span class="p">,</span> <span class="n">aliases</span><span class="p">)</span></div><div class='line' id='LC54'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">alias_paths</span> <span class="o">||=</span> <span class="nb">Array</span><span class="o">.</span><span class="n">new</span></div><div class='line' id='LC55'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">alias_paths</span> <span class="o">&lt;&lt;</span> <span class="n">aliases</span></div><div class='line' id='LC56'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">alias_paths</span><span class="o">.</span><span class="n">compact!</span></div><div class='line' id='LC57'><br/></div><div class='line' id='LC58'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">alias_paths</span><span class="o">.</span><span class="n">flatten</span><span class="o">.</span><span class="n">each</span> <span class="k">do</span> <span class="o">|</span><span class="n">alias_path</span><span class="o">|</span></div><div class='line' id='LC59'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">alias_path</span> <span class="o">=</span> <span class="n">alias_path</span><span class="o">.</span><span class="n">to_s</span></div><div class='line' id='LC60'><br/></div><div class='line' id='LC61'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">alias_dir</span>  <span class="o">=</span> <span class="no">File</span><span class="o">.</span><span class="n">extname</span><span class="p">(</span><span class="n">alias_path</span><span class="p">)</span><span class="o">.</span><span class="n">empty?</span> <span class="p">?</span> <span class="n">alias_path</span> <span class="p">:</span> <span class="no">File</span><span class="o">.</span><span class="n">dirname</span><span class="p">(</span><span class="n">alias_path</span><span class="p">)</span></div><div class='line' id='LC62'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">alias_file</span> <span class="o">=</span> <span class="no">File</span><span class="o">.</span><span class="n">extname</span><span class="p">(</span><span class="n">alias_path</span><span class="p">)</span><span class="o">.</span><span class="n">empty?</span> <span class="p">?</span> <span class="s2">&quot;index.html&quot;</span> <span class="p">:</span> <span class="no">File</span><span class="o">.</span><span class="n">basename</span><span class="p">(</span><span class="n">alias_path</span><span class="p">)</span></div><div class='line' id='LC63'><br/></div><div class='line' id='LC64'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">fs_path_to_dir</span>   <span class="o">=</span> <span class="no">File</span><span class="o">.</span><span class="n">join</span><span class="p">(</span><span class="vi">@site</span><span class="o">.</span><span class="n">dest</span><span class="p">,</span> <span class="n">alias_dir</span><span class="p">)</span></div><div class='line' id='LC65'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">alias_index_path</span> <span class="o">=</span> <span class="no">File</span><span class="o">.</span><span class="n">join</span><span class="p">(</span><span class="n">alias_dir</span><span class="p">,</span> <span class="n">alias_file</span><span class="p">)</span></div><div class='line' id='LC66'><br/></div><div class='line' id='LC67'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="no">FileUtils</span><span class="o">.</span><span class="n">mkdir_p</span><span class="p">(</span><span class="n">fs_path_to_dir</span><span class="p">)</span></div><div class='line' id='LC68'><br/></div><div class='line' id='LC69'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="no">File</span><span class="o">.</span><span class="n">open</span><span class="p">(</span><span class="no">File</span><span class="o">.</span><span class="n">join</span><span class="p">(</span><span class="n">fs_path_to_dir</span><span class="p">,</span> <span class="n">alias_file</span><span class="p">),</span> <span class="s1">&#39;w&#39;</span><span class="p">)</span> <span class="k">do</span> <span class="o">|</span><span class="n">file</span><span class="o">|</span></div><div class='line' id='LC70'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">file</span><span class="o">.</span><span class="n">write</span><span class="p">(</span><span class="n">alias_template</span><span class="p">(</span><span class="n">destination_path</span><span class="p">))</span></div><div class='line' id='LC71'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC72'><br/></div><div class='line' id='LC73'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">(</span><span class="n">alias_index_path</span><span class="o">.</span><span class="n">split</span><span class="p">(</span><span class="s1">&#39;/&#39;</span><span class="p">)</span><span class="o">.</span><span class="n">size</span> <span class="o">+</span> <span class="mi">1</span><span class="p">)</span><span class="o">.</span><span class="n">times</span> <span class="k">do</span> <span class="o">|</span><span class="n">sections</span><span class="o">|</span></div><div class='line' id='LC74'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="vi">@site</span><span class="o">.</span><span class="n">static_files</span> <span class="o">&lt;&lt;</span> <span class="ss">Jekyll</span><span class="p">:</span><span class="ss">:AliasFile</span><span class="o">.</span><span class="n">new</span><span class="p">(</span><span class="vi">@site</span><span class="p">,</span> <span class="vi">@site</span><span class="o">.</span><span class="n">dest</span><span class="p">,</span> <span class="n">alias_index_path</span><span class="o">.</span><span class="n">split</span><span class="p">(</span><span class="s1">&#39;/&#39;</span><span class="p">)</span><span class="o">[</span><span class="mi">0</span><span class="p">,</span> <span class="n">sections</span><span class="o">].</span><span class="n">join</span><span class="p">(</span><span class="s1">&#39;/&#39;</span><span class="p">),</span> <span class="kp">nil</span><span class="p">)</span></div><div class='line' id='LC75'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC76'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC77'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC78'><br/></div><div class='line' id='LC79'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">def</span> <span class="nf">alias_template</span><span class="p">(</span><span class="n">destination_path</span><span class="p">)</span></div><div class='line' id='LC80'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="o">&lt;&lt;-</span><span class="no">EOF</span></div><div class='line' id='LC81'><span class="sh">      &lt;!DOCTYPE html&gt;</span></div><div class='line' id='LC82'><span class="sh">      &lt;html&gt;</span></div><div class='line' id='LC83'><span class="sh">      &lt;head&gt;</span></div><div class='line' id='LC84'><span class="sh">      &lt;link rel=&quot;canonical&quot; href=&quot;#{destination_path}&quot;/&gt;</span></div><div class='line' id='LC85'><span class="sh">      &lt;meta http-equiv=&quot;content-type&quot; content=&quot;text/html; charset=utf-8&quot; /&gt;</span></div><div class='line' id='LC86'><span class="sh">      &lt;meta http-equiv=&quot;refresh&quot; content=&quot;0;url=#{destination_path}&quot; /&gt;</span></div><div class='line' id='LC87'><span class="sh">      &lt;/head&gt;</span></div><div class='line' id='LC88'><span class="sh">      &lt;/html&gt;</span></div><div class='line' id='LC89'><span class="no">      EOF</span></div><div class='line' id='LC90'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC91'>&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC92'><br/></div><div class='line' id='LC93'>&nbsp;&nbsp;<span class="k">class</span> <span class="nc">AliasFile</span> <span class="o">&lt;</span> <span class="no">StaticFile</span></div><div class='line' id='LC94'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nb">require</span> <span class="s1">&#39;set&#39;</span></div><div class='line' id='LC95'><br/></div><div class='line' id='LC96'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">def</span> <span class="nf">destination</span><span class="p">(</span><span class="n">dest</span><span class="p">)</span></div><div class='line' id='LC97'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="no">File</span><span class="o">.</span><span class="n">join</span><span class="p">(</span><span class="n">dest</span><span class="p">,</span> <span class="vi">@dir</span><span class="p">)</span></div><div class='line' id='LC98'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC99'><br/></div><div class='line' id='LC100'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">def</span> <span class="nf">modified?</span></div><div class='line' id='LC101'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span> <span class="kp">false</span></div><div class='line' id='LC102'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC103'><br/></div><div class='line' id='LC104'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">def</span> <span class="nf">write</span><span class="p">(</span><span class="n">dest</span><span class="p">)</span></div><div class='line' id='LC105'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span> <span class="kp">true</span></div><div class='line' id='LC106'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC107'>&nbsp;&nbsp;<span class="k">end</span></div><div class='line' id='LC108'><span class="k">end</span></div></pre></div>
          </td>
        </tr>
      </table>
  </div>

          </div>
        </div>

        <a href="#jump-to-line" rel="facebox" data-hotkey="l" class="js-jump-to-line" style="display:none">Jump to Line</a>
        <div id="jump-to-line" style="display:none">
          <h2>Jump to Line</h2>
          <form accept-charset="UTF-8" class="js-jump-to-line-form">
            <input class="textfield js-jump-to-line-field" type="text">
            <div class="full-button">
              <button type="submit" class="button">Go</button>
            </div>
          </form>
        </div>

      </div>
    </div>
</div>

<div id="js-frame-loading-template" class="frame frame-loading large-loading-area" style="display:none;">
  <img class="js-frame-loading-spinner" src="https://a248.e.akamai.net/assets.github.com/images/spinners/octocat-spinner-128.gif?1359500886" height="64" width="64">
</div>


        </div>
      </div>
      <div class="context-overlay"></div>
    </div>

      <div id="footer-push"></div><!-- hack for sticky footer -->
    </div><!-- end of wrapper - hack for sticky footer -->

      <!-- footer -->
      <div id="footer">
  <div class="container clearfix">

      <dl class="footer_nav">
        <dt>GitHub</dt>
        <dd><a href="https://github.com/about">About us</a></dd>
        <dd><a href="https://github.com/blog">Blog</a></dd>
        <dd><a href="https://github.com/contact">Contact &amp; support</a></dd>
        <dd><a href="http://enterprise.github.com/">GitHub Enterprise</a></dd>
        <dd><a href="http://status.github.com/">Site status</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Applications</dt>
        <dd><a href="http://mac.github.com/">GitHub for Mac</a></dd>
        <dd><a href="http://windows.github.com/">GitHub for Windows</a></dd>
        <dd><a href="http://eclipse.github.com/">GitHub for Eclipse</a></dd>
        <dd><a href="http://mobile.github.com/">GitHub mobile apps</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Services</dt>
        <dd><a href="http://get.gaug.es/">Gauges: Web analytics</a></dd>
        <dd><a href="http://speakerdeck.com">Speaker Deck: Presentations</a></dd>
        <dd><a href="https://gist.github.com">Gist: Code snippets</a></dd>
        <dd><a href="http://jobs.github.com/">Job board</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Documentation</dt>
        <dd><a href="http://help.github.com/">GitHub Help</a></dd>
        <dd><a href="http://developer.github.com/">Developer API</a></dd>
        <dd><a href="http://github.github.com/github-flavored-markdown/">GitHub Flavored Markdown</a></dd>
        <dd><a href="http://pages.github.com/">GitHub Pages</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>More</dt>
        <dd><a href="http://training.github.com/">Training</a></dd>
        <dd><a href="https://github.com/edu">Students &amp; teachers</a></dd>
        <dd><a href="http://shop.github.com">The Shop</a></dd>
        <dd><a href="/plans">Plans &amp; pricing</a></dd>
        <dd><a href="http://octodex.github.com/">The Octodex</a></dd>
      </dl>

      <hr class="footer-divider">


    <p class="right">&copy; 2013 <span title="0.13374s from fe19.rs.github.com">GitHub</span>, Inc. All rights reserved.</p>
    <a class="left" href="https://github.com/">
      <span class="mega-icon mega-icon-invertocat"></span>
    </a>
    <ul id="legal">
        <li><a href="https://github.com/site/terms">Terms of Service</a></li>
        <li><a href="https://github.com/site/privacy">Privacy</a></li>
        <li><a href="https://github.com/security">Security</a></li>
    </ul>

  </div><!-- /.container -->

</div><!-- /.#footer -->


    <div class="fullscreen-overlay js-fullscreen-overlay" id="fullscreen_overlay">
  <div class="fullscreen-container js-fullscreen-container">
    <div class="textarea-wrap">
      <textarea name="fullscreen-contents" id="fullscreen-contents" class="js-fullscreen-contents" placeholder="" data-suggester="fullscreen_suggester"></textarea>
          <div class="suggester-container">
              <div class="suggester fullscreen-suggester js-navigation-container" id="fullscreen_suggester"
                 data-url="/tsmango/jekyll_alias_generator/suggestions/commit">
              </div>
          </div>
    </div>
  </div>
  <div class="fullscreen-sidebar">
    <a href="#" class="exit-fullscreen js-exit-fullscreen tooltipped leftwards" title="Exit Zen Mode">
      <span class="mega-icon mega-icon-normalscreen"></span>
    </a>
    <a href="#" class="theme-switcher js-theme-switcher tooltipped leftwards"
      title="Switch themes">
      <span class="mini-icon mini-icon-brightness"></span>
    </a>
  </div>
</div>



    <div id="ajax-error-message" class="flash flash-error">
      <span class="mini-icon mini-icon-exclamation"></span>
      Something went wrong with that request. Please try again.
      <a href="#" class="mini-icon mini-icon-remove-close ajax-error-dismiss"></a>
    </div>

    
    
    <span id='server_response_time' data-time='0.13422' data-host='fe19'></span>
    
  </body>
</html>

