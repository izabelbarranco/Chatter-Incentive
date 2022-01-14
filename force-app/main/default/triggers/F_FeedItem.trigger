trigger F_FeedItem on FeedItem (after insert, after update) { 
    System.debug('entrei na trigger');
    new FieloFeedItemHandler().handle(); 
}