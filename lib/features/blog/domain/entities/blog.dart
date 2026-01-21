class Blog {
  final String id;
  final String user_id;
  final DateTime created_at;
  final String title;
  final String content;
  final String? username;
  final String image_url;

  Blog({
    required this.id,
    required this.user_id,
    required this.created_at, 
    required this.title, 
    required this.content, 
    required this.image_url,
    this.username,
    }
  );
}