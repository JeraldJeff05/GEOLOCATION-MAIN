import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AboutUsPage extends StatelessWidget {
  final List<TeamMember> teamMembers = [
    TeamMember(
      name: 'Jerald Jeff Madera',
      role: 'Team Leader,Frontend Developer,UI/UX Designer',
      bio:
          'Leads with a holistic approach, managing both development and design',
      imagePath: 'assets/team/jeff.webp',
      skills: [
        'Flutter',
        'Frontend Architecture',
        'System Design',
        'UI/UX design',
        'Canva'
      ],
      socialLinks: {'LinkedIn': '', 'Instagram': ''},
    ),
    TeamMember(
      name: 'Brandon Kyle Monteagudo',
      role: 'Frontend Developer, UI/UX Designer',
      bio:
          'Focuses on front-end refinement and employee dashboard functionalities.',
      imagePath: 'assets/team/kyle.webp',
      skills: ['Flutter', 'User Research'],
      socialLinks: {'Dribbble': '', 'Behance': ''},
    ),
    TeamMember(
      name: 'Adrielle Young',
      role: 'Backend Developer, Database Manager',
      bio:
          'Architecting robust and scalable backend systems that power our applications.',
      imagePath: 'assets/team/ady.jpeg',
      skills: [
        'Go language',
        'Database Optimization',
        'Python',
        'Cloud Computing'
      ],
      socialLinks: {'LinkedIn': '', 'GitHub': ''},
    ),
    TeamMember(
      name: 'Vincent Canilao',
      role: 'Quality Assurance, Support Role',
      bio: 'Supports and verifies the functionality, playing a QA role.',
      imagePath: 'assets/team/vincent.jpeg',
      skills: ['System Testing', 'Website polishing'],
      socialLinks: {'LinkedIn': '', 'Twitter': ''},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Our Team'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Meet the Innovators Behind Our Platform',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return TeamMemberCard(teamMember: teamMembers[index]);
                },
                childCount: teamMembers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TeamMember {
  final String name;
  final String role;
  final String bio;
  final String imagePath;
  final List<String> skills;
  final Map<String, String> socialLinks;

  TeamMember({
    required this.name,
    required this.role,
    required this.bio,
    required this.imagePath,
    required this.skills,
    required this.socialLinks,
  });
}

class TeamMemberCard extends StatefulWidget {
  final TeamMember teamMember;

  const TeamMemberCard({Key? key, required this.teamMember}) : super(key: key);

  @override
  _TeamMemberCardState createState() => _TeamMemberCardState();
}

class _TeamMemberCardState extends State<TeamMemberCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF333A3A)
                    .withOpacity(0.7), // Replace with your desired color
                Color(0xFF333A3A).withOpacity(0.7),
              ],
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage(widget.teamMember.imagePath),
                    )
                        .animate()
                        .scale(duration: 500.ms)
                        .fadeIn(duration: 500.ms),
                    SizedBox(height: 16),
                    Text(
                      widget.teamMember.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.teamMember.role,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (_isExpanded) ...[
                      Text(
                        widget.teamMember.bio,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.teamMember.skills
                            .map((skill) => Chip(
                                  label: Text(skill),
                                  backgroundColor: Colors.black,
                                  labelStyle: TextStyle(color: Colors.white),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.teamMember.socialLinks.entries
                            .map((entry) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Implement URL launch logic
                                    },
                                    icon: Icon(Icons.link),
                                    label: Text(entry.key),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white24,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      )
          .animate()
          .slideY(begin: 0.5, end: 0, duration: 500.ms)
          .fadeIn(duration: 500.ms),
    );
  }
}
