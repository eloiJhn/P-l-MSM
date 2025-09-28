import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        // Image de fond plein écran
        Positioned.fill(
          child: Image.asset(
            'assets/images/Mont_St_Michel.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.3),
          ),
        ),
        // Dégradé pour fondre l'image avec le contenu et assurer la lisibilité
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.35),
                  Colors.white.withOpacity(0.0),
                  Colors.white,
                ],
                stops: const [0.0, 0.45, 0.85],
              ),
            ),
          ),
        ),
        // Contenu scrollable
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              children: [
                // Logo discret
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'assets/images/logo_msm_transparent.svg',
                    height: 72,
                    colorFilter: const ColorFilter.mode(kBlanc, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(height: 160),
                // Carte de bienvenue
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kOutremer.withOpacity(0.2), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: kDore.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Bienvenue au pèlerinage des jeunes',
                              style: leagueSpartanStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: kDore,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'Le Mont Saint-Michel',
                            style: leagueSpartanStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: kMarine,
                              height: 1.15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _p('Cher ami,\nBienvenue à notre pèlerinage des jeunes du Grand Ouest au Mont Saint-Michel ! Que ce soit une expérience nouvelle pour toi ou que tu sois déjà un pèlerin chevronné, nous sommes heureux de marcher avec toi.'),
                        const SizedBox(height: 12),
                        _p("Ce rocher, dressé au cœur de la baie, pointant vers le ciel, n’est pas seulement un chef-d’œuvre de nature et d’architecture, c’est aussi un signe spirituel puissant. Depuis plus de mille ans, il attire pèlerins, chercheurs de Dieu, aventuriers de la foi."),
                        const SizedBox(height: 12),
                        _p('Notre thème est simple et radical : « Soyez saints » (1 P 1,16). Une parole, ciselée comme un rocher, qui frappe et met en marche. La sainteté n’est pas réservée à quelques moines, prêtres ou grandes figures canonisées. Elle est l’appel adressé à chacun de nous, étudiants, jeunes pros, au cœur de nos études ou de notre travail, de nos choix d’avenir, de nos amitiés, de nos combats.'),
                        const SizedBox(height: 14),
                        _bullet('Comme saint Michel, nous sommes appelés à mettre Dieu au centre, et à proclamer par notre vie : « Qui est comme Dieu ? »'),
                        _bullet('Comme le Mont, enraciné dans le rocher et tendu vers le ciel, nous sommes invités à construire nos vies sur le Christ, solides dans la foi.'),
                        _bullet('Comme les générations de pèlerins avant nous, nous avançons ensemble, en frères et sœurs, vers le Christ qui nous attire à lui.'),
                        const SizedBox(height: 14),
                        _p('Vivons ce temps de pèlerinage comme une parabole de notre vie : un chemin où l’effort se fait sentir, parfois troublé par les sables mouvants, mais orienté vers un but lumineux qui nous attire et nous guide.'),
                        const SizedBox(height: 12),
                        _p('Que ce pèlerinage soit pour toi, en ce début d’année, l’occasion de centrer ta vie sur l’Essentiel et de faire l’expérience joyeuse et stimulante de la fraternité chrétienne.'),
                        const SizedBox(height: 18),
                        Text(
                          'Bon pèlerinage !',
                          style: leagueSpartanStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kDore,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Paragraphe standard
  Widget _p(String text) => Text(
        text,
        style: leagueSpartanStyle(
          fontSize: 16,
          height: 1.5,
          color: kNoir.withOpacity(0.9),
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.left,
      );

  // Puce typée
  Widget _bullet(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(color: kDore, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: leagueSpartanStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: kNoir.withOpacity(0.9),
                ),
              ),
            )
          ],
        ),
      );
}
