class Lang {
  static const String appName = 'Rice Cake Montage';

  static const String guideSkip = 'Skip';
  static const String guideNext = 'Next';
  static const String guideStart = 'Get started';
  static const String guideTitle1 = 'Big world, easy edits';
  static const String guideDesc1 =
      'Turn photos and short clips into warm montages with music and captions.';
  static const String guideTitle2 = 'Solid templates, rich themes';
  static const String guideDesc2 =
      'Family, birthdays, travel, holidays, and more—build your story scene by scene.';
  static const String guideTitle3 = 'Discover ideas, curate favorites';
  static const String guideDesc3 =
      'Browse featured work by category and save what you like to your local favorites.';

  static const String navHome = 'Discover';
  static const String navCreate = 'Create';
  static const String navProfile = 'Me';

  static const String homeTitle = 'Discover';
  static const String homeSubtitle = 'Ideas and your best work';
  static const String homeFeatured = 'Featured';
  static const String homeFeaturedEmpty =
      'No finished montages yet. Tap “Save” on the editor and they will show up here.';
  static const String homeSeeAll = 'See all';
  static const String homeCreateCta = 'Create a montage';
  static const String homeRankingChip = 'My favorites';
  static const String homeRecentDrafts = 'Recent drafts';
  static const String homeDraftsSeeAll = 'All drafts';

  static const String createTitle = 'Create';
  static const String createPickTemplate = 'Choose a template';
  static const String createStart = 'Start from a template';
  static const String createHeroSubtitle =
      'Pick a theme, add photos, add captions, and finish a montage on device.';
  static const String createSectionTemplates = 'Scene templates';
  static const String createTapHint = 'Tap to open the media picker';
  static const String createSteps = 'Template → Media → Edit → Save';
  static const String createSceneBadgeSuffix = ' scenes';

  static const String profileTitle = 'Me';
  static const String profileMyWorks = 'My works';
  static const String profileDrafts = 'Drafts';
  static const String profileRanking = 'My favorites';
  static const String profileStats = 'Stats';
  static const String profileHelp = 'Help';
  static const String profileAbout = 'About';
  static const String profileStatPublished = 'Published';
  static const String profileStatDrafts = 'Drafts';
  static const String profileStatFavorites = 'Favorites';

  static const String myWorksTitle = 'My works';
  static const String draftsTitle = 'Drafts';
  static const String actionDelete = 'Delete';
  static const String draftDeleteTitle = 'Delete this draft?';
  static const String draftDeleteCancel = 'Cancel';
  static const String rankingTitle = 'My favorites';
  static const String statsTitle = 'Stats';
  static const String helpTitle = 'Help';
  static const String aboutTitle = 'About';

  static const String featuredListTitle = 'Featured list';
  static const String featuredListEmpty = 'No finished montages yet';
  static const String workDetailTitle = 'Work detail';

  static const String emptyWorks = 'No works yet—start a new story';
  static const String emptyDrafts = 'No drafts';
  static const String emptyRanking =
      'No favorites yet. Tap the star on a work to add it here.';

  static const String statsWorks = 'Total published';
  static const String statsDrafts = 'Draft count';
  static const String statsStreak = 'Creation streak (days)';
  static const String statsWeekly = 'This week';
  static const String statsWeeklyCaption =
      'Finished montages per day over the last 7 days';
  static String statsWeekdayChar(int weekday) {
    const List<String> d = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    if (weekday < 1 || weekday > 7) {
      return '';
    }
    return d[weekday - 1];
  }

  static const String favoriteAdd = 'Add to favorites';
  static const String favoriteAdded = 'Favorited';
  static const String actionPreview = 'Preview';
  static const String actionEdit = 'Continue editing';

  static const String helpBodyTitle = 'Help';
  static const String aboutBodyTitle = 'About';

  static const String pickMediaTitle = 'Choose media';
  static const String pickMediaHint =
      'Pick multiple photos from the library. You can remove thumbnails anytime. Keep at least one before editing.';
  static const String pickMediaGallery = 'Choose from library';
  static const String pickMediaEmpty = 'No photos selected';
  static const String pickMediaNext = 'Edit captions';
  static const String pickMediaNeedOne = 'Select at least one photo first';
  static const String errorMissingWork = 'Unable to open this screen';
  static const String pickMediaSingleFallback =
      'Multi-select failed; using single pick. Tap again to add more.';
  static const String pickMediaPlatformError =
      'Could not open the library. Fully quit the app and retry, or run cd ios && pod install then rebuild.';

  static const String editWorkbenchTitle = 'Edit montage';
  static const String editSaveDraft = 'Save draft';
  static const String editTitleLabel = 'Title';
  static const String editCaptionSection = 'Captions per slide';
  static const String editSlideCaption = 'Caption';
  static const String editSave = 'Save';
  static const String editSaveDone = 'Saved';
  static const String editEmptyStateSubtitle =
      'Add photos from your library, then write a caption for each slide.';
  static String editSlidesSummary(int count) {
    if (count <= 0) {
      return '0 slides';
    }
    if (count == 1) {
      return '1 slide';
    }
    return '$count slides';
  }

  static const String previewTitle = 'Preview';

  static const String featuredSortFavoriteFirst = 'Favorites first';
  static const String featuredSortTime = 'By time';
  static const String featuredFilterAll = 'All';
  static const String featuredSortTitle = 'Sort';
}
